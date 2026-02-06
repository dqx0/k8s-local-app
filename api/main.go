package main

import (
	"encoding/json"
	"log"
	"math/rand/v2"
	"net/http"
	"os"
	"time"
)

type apiResponse struct {
	Service   string `json:"service"`
	Status    string `json:"status"`
	Hostname  string `json:"hostname"`
	Timestamp string `json:"timestamp"`
}

type diceResponse struct {
	Value     int    `json:"value"`
	Hostname  string `json:"hostname"`
	Timestamp string `json:"timestamp"`
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", withCORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		if r.URL.Path == "/health" {
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(map[string]string{"status": "healthy"})
			return
		}
		if r.URL.Path == "/dice" {
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(diceResponse{
				Value:     rand.IntN(6) + 1,
				Hostname:  hostname(),
				Timestamp: time.Now().UTC().Format(time.RFC3339Nano),
			})
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(apiResponse{
			Service:   "api.dqx0",
			Status:    "ok",
			Hostname:  hostname(),
			Timestamp: time.Now().UTC().Format(time.RFC3339Nano),
		})
	}))

	srv := &http.Server{
		Addr:              ":8080",
		Handler:           mux,
		ReadHeaderTimeout: 5 * time.Second,
	}

	log.Println("api listening on :8080")
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}

func hostname() string {
	h, err := os.Hostname()
	if err != nil {
		return "unknown"
	}
	return h
}

func withCORS(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		next(w, r)
	}
}
