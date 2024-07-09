.PHONY: help
help:						## Display this help text for Makefile
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.state/container: Dockerfile		## Build the container
	@echo "Building container"
	@docker build -t psf-package-builder .
	@mkdir -p .state && touch .state/container

# ----------------
# -- Core Targets
# ----------------
.PHONY: amd64
amd64: .state/container			## Build latest for AMD64
	@echo "Building for AMD64"
	@docker run --rm -v "$(pwd)/builds:/build/builds" psf-package-builder /build/tools/build_deb.sh -a amd64

.PHONY: arm
arm: .state/container		 ## Build latest for ARM
	@echo "Building for ARM"
	@docker run --rm -v "$(pwd)/builds:/build/builds" psf-package-builder /build/tools/build_deb.sh -a arm64

.PHONY: all					 ## Build latest for both AMD64 and ARM
all: amd64 arm

.PHONY: upload
upload:						## Upload the package to PackageCloud
	@echo "Uploading to PackageCloud..."
	# TODO: Implement upload

# ----------------
# Utilities / Uncommon Targets
# ----------------
.PHONY: clean
clean:						## Clean up the build artifacts
	@echo "Cleaning up your mess..."
	@rm -rf builds/*
	@rm -rf .state

.PHONY: manual-build
manual: 					## Locally build the package with tools/build_deb.sh
	@echo "Manually building package"
	@tools/build_deb.sh

.PHONY: amd64-nobump
amd64-nobump: .state/container	## Build latest for AMD64 without bumping version
	@echo "Building for AMD64 without bumping version"
	@docker run --rm -v "$(pwd):/build" psf-package-builder /build/tools/build_deb.sh -a amd64 -K

.PHONY: arm-nobump
arm-nobump: .state/container	## Build latest for ARM without bumping version
	@echo "Building for ARM without bumping version"
	@docker run --rm -v "$(pwd):/build" psf-package-builder /build/tools/build_deb.sh -a arm64 -K

.PHONY: all-nobump			 ## Build latest for both AMD64 and ARM without bumping version
all-nobump: amd64-nobump arm-nobump
