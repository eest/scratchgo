package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	ts := time.Now().Format(time.RFC3339)
	fmt.Fprintf(w, "scratchgo is alive and the time is %s\n", ts)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
