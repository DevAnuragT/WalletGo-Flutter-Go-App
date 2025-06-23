package services

import (
	"context"
	"time"
	"walletgo/pkg/db"
)

type User struct {
	UID     string `json:"uid" bson:"_id"`
	Name    string `json:"name"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
	Balance int    `json:"balance"`
}

func CreateUser(u User) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	u.Balance = 1000 // Default balance

	_, err := db.DB.Collection("users").InsertOne(ctx, u)
	return err
}
