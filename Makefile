.PHONY: build publish version help

help:
	@echo "Available targets:"
	@echo "  build   - Compile the image"
	@echo "  publish - Publish the image to Docker Hub"
	@echo "  version - Tag a new release point"
	@echo "  help    - Show this help message"

build:
	./run/build

publish:
	./run/publish

version:
	./run/version
