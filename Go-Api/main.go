package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Person struct {
	Name string
}

func handler(w http.ResponseWriter, r *http.Request) {
	// Create a new Person struct.
	person := Person{Name: "Tyler"}

	// Convert the struct to JSON and check for errors.
	personBytes, err := json.Marshal(person)
	if err != nil {
		log.Fatal(err)
	}

	// Write the JSON to the response writer.
	fmt.Fprintf(w, string(personBytes))
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Listening on http://localhost:8081")
	http.ListenAndServe(":8081", nil)
}
