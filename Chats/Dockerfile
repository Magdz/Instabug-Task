FROM golang:latest 
RUN mkdir /app 
ADD . /app/ 
WORKDIR /app 

RUN go get github.com/gorilla/mux
RUN go get github.com/adjust/rmq

RUN go build -o main . 
CMD ["/app/main"]