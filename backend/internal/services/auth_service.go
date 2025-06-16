package services

import (
	"../../pkg/otp"
)

type User struct {
	Name    string `json:"name"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
	Balance int    `json:"balance"`
}

var userStore = make(map[string]User)

func SendOTP(phone string) string {
	return otp.GenerateOTP(phone)
}

func VerifyAndCreateUser(phone, otpCode, name, email string) (*User, error) {
	if !otp.VerifyOTP(phone, otpCode) {
		return nil, nil
	}

	if user, exists := userStore[phone]; exists {
		return &user, nil
	}

	user := User{
		Name:    name,
		Email:   email,
		Phone:   phone,
		Balance: 1000,
	}
	userStore[phone] = user
	return &user, nil
}
