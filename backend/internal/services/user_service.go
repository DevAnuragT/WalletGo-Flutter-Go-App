package services

import (
	"context"
	"time"
	"walletgo/pkg/db"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	UID      string `json:"uid" bson:"_id"`
	Name     string `json:"name"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
	Balance  int    `json:"balance"`
	PINHash  string `json:"-" bson:"pinHash,omitempty"` // bcrypt hash for PIN
}


func SetUserPIN(uid, pin string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	hash, err := bcrypt.GenerateFromPassword([]byte(pin), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	_, err = db.DB.Collection("users").UpdateByID(ctx, uid, map[string]interface{}{
		"$set": map[string]string{"pinHash": string(hash)},
	})
	return err
}

func VerifyUserPIN(uid, inputPIN string) (bool, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var user User
	err := db.DB.Collection("users").FindOne(ctx, map[string]string{"_id": uid}).Decode(&user)
	if err != nil {
		return false, err
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.PINHash), []byte(inputPIN))
	if err != nil {
		return false, nil // PIN doesn't match
	}

	return true, nil
}


func CreateUser(u User) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	u.Balance = 10000 // Default balance(since using points instead of money)

	_, err := db.DB.Collection("users").InsertOne(ctx, u)
	return err
}
