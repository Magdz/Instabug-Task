package main

import (
	"fmt"
	"log"
	"net/http"
	"github.com/gorilla/mux"
	"github.com/adjust/rmq"
)

type Chat struct {

}

func homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "HomePage endpoint hit!")
}

func createChat(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	token := vars["token"]

	connection := rmq.OpenConnection("worker", "tcp", "localhost:6379", 1)
	queue := connection.OpenQueue("chats")

	queue.Publish(token)
}

func handleRequests() {
	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/", homePage).Methods("GET")
	router.HandleFunc("/applications/{token}/chats", createChat).Methods("POST")

	log.Fatal(http.ListenAndServe(":8081", router))
}

func main() {
	handleRequests()
}
