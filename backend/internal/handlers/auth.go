package handlers

import (
	"encoding/json"
	"net/http"
	"../services"
)

func SendOTPHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Phone string `json:"phone"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}
	code := services.SendOTP(req.Phone)
	// Mock "send" the OTP
	println("OTP for", req.Phone, "is", code)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "OTP sent"})
}

func VerifyOTPHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Name  string `json:"name"`
		Email string `json:"email"`
		Phone string `json:"phone"`
		OTP   string `json:"otp"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	user, err := services.VerifyAndCreateUser(req.Phone, req.OTP, req.Name, req.Email)
	if err != nil || user == nil {
		http.Error(w, "Invalid OTP", http.StatusUnauthorized)
		return
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}
