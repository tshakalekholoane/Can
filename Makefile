## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## clean: delete build artefacts
.PHONY: clean
clean:
	-rm -rf .build/ can

## release: compiles a multiarchitecture binary for amd64 and arm64
.PHONY: release
release:
	swift build --configuration release --triple arm64-apple-macosx
	swift build --configuration release --triple x86_64-apple-macosx
	lipo -create -output can .build/arm64-apple-macosx/release/can .build/x86_64-apple-macosx/release/can
