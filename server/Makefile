SOURCE=$(shell find . -iname "*.go")

.PHONY: all
all: | $(GOBIN)/main

.PHONY: clean
clean:
	rm -rf $(GOBIN)/main

.PHONY: core
main: $(GOBIN)/main

$(GOBIN)/main: $(SOURCE)
	go build -o $(GOBIN)/main \
	main.go