package handlers

import (
	"encoding/json"
	"net/http"
	"walletgo/internal/services"
)


func SetUserPINHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	type Request struct {
		UID string `json:"uid"`
		PIN string `json:"pin"`
	}

	var req Request
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if len(req.PIN) < 4 {
		http.Error(w, "PIN must be at least 4 digits", http.StatusBadRequest)
		return
	}

	err := services.SetUserPIN(req.UID, req.PIN)
	if err != nil {
		http.Error(w, "Error setting PIN", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "PIN set successfully",
	})
}

func VerifyUserPINHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	type Request struct {
		UID string `json:"uid"`
		PIN string `json:"pin"`
	}

	var req Request
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	valid, err := services.VerifyUserPIN(req.UID, req.PIN)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	if !valid {
		http.Error(w, "Invalid PIN", http.StatusUnauthorized)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "PIN verified successfully",
	})
}


func RegisterUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	var req services.User
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid body", http.StatusBadRequest)
		return
	}

	if err := services.CreateUser(req); err != nil {
		http.Error(w, "Error creating user", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"message": "User created"})
}
