.PHONY: build publish help

help:
	@echo "Available targets:"
	@echo "  build   - Compile the image"
	@echo "  publish - Publish the image to Docker Hub"
	@echo "  help    - Show this help message"

build:
	./run/build

publish:
	./run/publish
