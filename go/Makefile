# https://go.dev/dl/
GO_VERSION ?= 1.24.2

.PHONY: default
default: use/go-$(GO_VERSION)
	@echo export GOPATH="$(PWD)"
	@echo export PATH="$${GOPATH}/bin:$${GOPATH}/go/bin:$${PATH}"

use/go-%: dl/go-%
	mkdir -p use
	unlink go || true
	rm -f use/go-* \
	  && touch use/go-$* \
	  && ln -s ./dl/go-$* ./go

dl/go-%: dl/go-%.tar.gz
	cd dl && tar -xzf go-$*.tar.gz && mv go go-$*

dl/go-%.tar.gz:
	mkdir -p dl
	curl -L https://go.dev/dl/go$*.linux-amd64.tar.gz -o dl/go-$*.tar.gz

