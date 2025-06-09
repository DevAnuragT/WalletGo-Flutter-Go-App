package otp

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

var otpStore = make(map[string]string)
var mu sync.Mutex

func init() {
	rand.Seed(time.Now().UnixNano())
}

func GenerateOTP(phone string) string {
	mu.Lock()
	defer mu.Unlock()
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	otpStore[phone] = code
	return code
}

func VerifyOTP(phone, otp string) bool {
	mu.Lock()
	defer mu.Unlock()
	return otpStore[phone] == otp
}
