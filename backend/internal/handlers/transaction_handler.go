package handlers

import (
	"encoding/json"
	"net/http"
	"walletgo/internal/services"
)

type TransactionWithPIN struct {
	services.Transaction
	PIN string `json:"pin"`
}


func SendPoints(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	var t TransactionWithPIN
	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// 🔐 Verify PIN before proceeding
	ok, err := services.VerifyUserPIN(t.From, t.PIN)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	if !ok {
		http.Error(w, "Invalid PIN", http.StatusUnauthorized)
		return
	}

	err = services.CreateTransaction(t.Transaction)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"message": "Transaction successful"})
}
