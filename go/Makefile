# https://go.dev/dl/
GO_VERSION ?= 1.24.2

.PHONY: default
default: active/go-$(GO_VERSION)
	@echo export GOPATH="$(PWD)"
	@echo export PATH='$${GOPATH}/bin:$${GOPATH}/go/bin:$${PATH}'

active/go-%: dl/go-%
	mkdir -p active
	unlink go || true
	rm -f active/go-* \
	  && touch active/go-$* \
	  && ln -s ./dl/go-$* ./go

dl/go-%: dl/go-%.tar.gz
	cd dl && tar -xzf go-$*.tar.gz && mv go go-$*

dl/go-%.tar.gz:
	mkdir -p dl
	curl -L https://go.dev/dl/go$*.linux-amd64.tar.gz -o dl/go-$*.tar.gz

