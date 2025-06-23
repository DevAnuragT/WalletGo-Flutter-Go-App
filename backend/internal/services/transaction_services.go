package services

import (
	"context"
	"errors"
	"time"
	"walletgo/pkg/db"
)

type Transaction struct {
	From      string    `json:"from"`
	To        string    `json:"to"`
	Amount    int       `json:"amount"`
	Note      string    `json:"note"`
	Category  string    `json:"category"`
	Timestamp time.Time `json:"timestamp"`
}

func CreateTransaction(t Transaction) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	users := db.DB.Collection("users")
	transactions := db.DB.Collection("transactions")

	//check for both users exist
	var sender, receiver User
	if err := users.FindOne(ctx, map[string]string{"_id": t.From}).Decode(&sender); err != nil {
		return errors.New("sender not found")
	}
	if err := users.FindOne(ctx, map[string]string{"_id": t.To}).Decode(&receiver); err != nil {
		return errors.New("receiver not found")
	}

	if sender.Balance < t.Amount {
		return errors.New("insufficient balance")
	}

	_, err := users.UpdateByID(ctx, t.From, map[string]interface{}{
		"$inc": map[string]int{"balance": -t.Amount},
	})
	if err != nil {
		return err
	}

	_, err = users.UpdateByID(ctx, t.To, map[string]interface{}{
		"$inc": map[string]int{"balance": t.Amount},
	})
	if err != nil {
		return err
	}

	//transaction record
	t.Timestamp = time.Now()
	_, err = transactions.InsertOne(ctx, t)
	return err
}
