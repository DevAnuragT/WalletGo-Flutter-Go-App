package handlers

import (
	"encoding/json"
	"net/http"
	"walletgo/internal/services"
)

type SplitRequestBody struct {
	From        string   `json:"from"`
	Recipients  []string `json:"recipients"`
	TotalAmount int      `json:"total_amount"`
	Note        string   `json:"note"`
	Category    string   `json:"category"`
}

func SplitBillHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	var req SplitRequestBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	err := services.CreateSplitRequests(req.From, req.Recipients, req.TotalAmount, req.Note, req.Category)
	if err != nil {
		http.Error(w, "Failed to create requests", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{
		"message": "Split requests created successfully",
	})
}

func RespondToRequestHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		return
	}

	type Body struct {
		RequestID string `json:"request_id"`
		Action    string `json:"action"` // "accept" or "reject"
	}

	var req Body
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid body", http.StatusBadRequest)
		return
	}

	if req.Action != "accept" && req.Action != "reject" {
		http.Error(w, "Invalid action", http.StatusBadRequest)
		return
	}

	if err := services.RespondToRequest(req.RequestID, req.Action); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	json.NewEncoder(w).Encode(map[string]string{"message": "Request " + req.Action + "ed"})
}