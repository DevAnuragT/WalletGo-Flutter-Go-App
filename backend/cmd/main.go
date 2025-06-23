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
	log.Println("🚀 Server started at :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
