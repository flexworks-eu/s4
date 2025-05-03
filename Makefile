.PHONY: run build  docker test docker-with-tests

include .env
export

VERSION := $(shell cat VERSION.txt)
DIST := dist
APP := s4docs
TARGET_ARCH := arm64
TARGET_OS := linux

clean:
	rm -rf dist
	rm -rf tmp

run: build
	@./bin/$(APP)

build:
	@templ generate
	go build -ldflags "-X bamventora/handlers.Version=$(VERSION)" -o bin/$(APP) .


docker:
	@echo "building version: $(VERSION)"
	@templ generate
	GOARCH=$(TARGET_ARCH) GOOS=$(TARGET_OS) CGO_ENABLED=0 go build -ldflags "-X bamventora/handlers.Version=$(VERSION)"  -o $(DIST)/$(APP)
	docker build -t $(APP):$(VERSION) .

docker-run: docker
	docker run -it --rm -p $(PORT):$(PORT) $(APP):$(VERSION)

docker-deploy: test docker
	@docker tag $(APP):$(VERSION) $(DOCKERHOST)/$(APP):$(VERSION)
	@docker push $(DOCKERHOST)/$(APP):$(VERSION)
	@docker-compose down
	@docker-compose up -d