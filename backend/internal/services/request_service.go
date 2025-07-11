package services

import (
	"context"
	"errors"
	"time"

	"walletgo/pkg/db"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type PointRequest struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	From      string             `bson:"from" json:"from"`
	To        string             `bson:"to" json:"to"`
	Amount    int                `bson:"amount" json:"amount"`
	Note      string             `bson:"note" json:"note"`
	Category  string             `bson:"category" json:"category"`
	Status    string             `bson:"status" json:"status"` // pending, accepted, rejected
	CreatedAt time.Time          `bson:"created_at" json:"created_at"`
}

func CreateSplitRequests(from string, recipients []string, totalAmount int, note, category string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if len(recipients) == 0 {
		return nil
	}

	amountPerUser := totalAmount / len(recipients)
	var docs []interface{}

	for _, to := range recipients {
		docs = append(docs, PointRequest{
			From:      from,
			To:        to,
			Amount:    amountPerUser,
			Note:      note,
			Category:  category,
			Status:    "pending",
			CreatedAt: time.Now(),
		})
	}

	_, err := db.DB.Collection("requests").InsertMany(ctx, docs)
	return err
}

func RespondToRequest(requestID string, action string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	requests := db.DB.Collection("requests")

	//Fetching request
	objID, err := primitive.ObjectIDFromHex(requestID)
	if err != nil {
		return errors.New("invalid request ID")
	}

	var req PointRequest
	if err := requests.FindOne(ctx, bson.M{"_id": objID}).Decode(&req); err != nil {
		return errors.New("request not found")
	}

	if req.Status != "pending" {
		return errors.New("request already handled")
	}

	//If accepted → do transaction
	if action == "accept" {
		txn := Transaction{
			From:      req.To,
			To:        req.From,
			Amount:    req.Amount,
			Note:      req.Note,
			Category:  req.Category,
			Timestamp: time.Now(),
		}
		if err := CreateTransaction(txn); err != nil {
			return err
		}
	}

	//Updating request status
	_, err = requests.UpdateByID(ctx, objID, bson.M{
	"$set": bson.M{"status": action},
	})
	return err
}
