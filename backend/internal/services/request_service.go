package services

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"walletgo/pkg/db"
)

type PointRequest struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	From      string             `json:"from"`
	To        string             `json:"to"`
	Amount    int                `json:"amount"`
	Note      string             `json:"note"`
	Category  string             `json:"category"`
	Status    string             `json:"status"` // pending, accepted, rejected
	CreatedAt time.Time          `json:"created_at"`
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
