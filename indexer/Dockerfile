FROM golang:1.14-alpine

WORKDIR /app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...
RUN gunzip products.json.gz
RUN rm main.go go.mod go.sum
