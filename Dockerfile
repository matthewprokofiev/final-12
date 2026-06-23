FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /parcel .

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /parcel /app/parcel
COPY --from=builder /app/tracker.db /app/tracker.db

CMD ["/app/parcel"]
