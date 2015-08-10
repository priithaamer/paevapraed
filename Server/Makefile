prefix = build

all: fmt
	
fmt:
	go fmt ./...

prepare:
	mkdir -p build

build: prepare
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${prefix}/paevapraed_server

clean:
	rm -rf build
