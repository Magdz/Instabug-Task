package main

import (
	"fmt"
	"log"
	"net/http"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/adjust/rmq"
)

type Message struct {
	AppToken string
	ChatID string
	Text string
}

func homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "HomePage endpoint hit!")
}

func createChat(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	token := vars["token"]

	connection := rmq.OpenConnection("publisher", "tcp", "queue:6379", 1)
	queue := connection.OpenQueue("chats")

	queue.Publish(token)
	fmt.Fprintf(w, "Accepted!")
}

func createMsg(w http.ResponseWriter, r *http.Request) {
	var msg Message

	vars := mux.Vars(r)
	msg.ChatID = vars["id"]
	msg.AppToken = vars["token"]

	decoder := json.NewDecoder(r.Body)
	decoder.Decode(&msg)
	defer r.Body.Close()
	
	j, err := json.Marshal(msg)
	if err != nil {
	}

	connection := rmq.OpenConnection("publisher", "tcp", "queue:6379", 1)
	queue := connection.OpenQueue("messages")
	
	queue.Publish(string(j))
	fmt.Fprintf(w, "Accepted!")
}

func handleRequests() {
	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/", homePage).Methods("GET")
	router.HandleFunc("/applications/{token}/chats", createChat).Methods("POST")
	router.HandleFunc("/applications/{token}/chats/{id}/messages", createMsg).Methods("POST")

	log.Fatal(http.ListenAndServe(":8081", router))
}

func main() {
	handleRequests()
}
