package main

import (
	"log"
	"net/http"
	"../internal/handlers"
)

func main() {
	http.HandleFunc("/send-otp", handlers.SendOTPHandler)
	http.HandleFunc("/verify-otp", handlers.VerifyOTPHandler)

	log.Println("Server running at http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
