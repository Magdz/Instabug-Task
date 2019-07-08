package main

import (
	"fmt"
	"log"
	"net/http"
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/kavu/go-resque" // Import this package
	_ "github.com/kavu/go-resque/godis" // Use godis driver
	"github.com/simonz05/godis/redis" // Redis client from godis package
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

	client := redis.New("tcp:127.0.0.1:6379", 0, "")
	enqueuer := resque.NewRedisEnqueuer("godis", client, "resque:")
	
	_, err := enqueuer.Enqueue("resque:queue:chats", token)
	if err != nil {
		panic(err)
	}

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

	
	client := redis.New("tcp:127.0.0.1:6379", 0, "")
	enqueuer := resque.NewRedisEnqueuer("godis", client, "resque:")
	
	_, err = enqueuer.Enqueue("resque:queue:messages", string(j))
	if err != nil {
		panic(err)
	}

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
