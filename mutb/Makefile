IMAGE_NAME = mutb
TAG = latest
FULL_TAG = $(IMAGE_NAME):$(TAG)

.PHONY: build clean rebuild run

## Build the docker image
build:
	docker build -t $(FULL_TAG) .

## Remove the image completely
clean:
	@if docker image inspect $(FULL_TAG) >/dev/null 2>&1; then \
		echo "Removing $(FULL_TAG)"; \
		docker rmi $(FULL_TAG); \
	else \
		echo "$(FULL_TAG) not found, nothing to remove"; \
	fi

## Rebuild from scratch
rebuild: clean build

## Run a command inside the container (like your wrapper function)
## Usage: make run cmd="bash -c 'ls -la'"
run:
	docker run --rm -it \
		-v "$$PWD":"$$PWD" \
		-w "$$PWD" \
		--user "$$(id -u):$$(id -g)" \
		$(FULL_TAG) $$cmd