package main

import (
	"log"
	"net/http"

	"walletgo/internal/handlers"
	"walletgo/pkg/db"
)

func main() {
	db.InitMongo()

	http.HandleFunc("/api/register", handlers.RegisterUser)
	http.HandleFunc("/api/transfer", handlers.SendPoints)
	http.HandleFunc("/api/set-pin", handlers.SetUserPINHandler)
	http.HandleFunc("/api/verify-pin", handlers.VerifyUserPINHandler)
	http.HandleFunc("/api/split-bill", handlers.SplitBillHandler)
	http.HandleFunc("/api/respond-request", handlers.RespondToRequestHandler)

	log.Println("Server started at :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
