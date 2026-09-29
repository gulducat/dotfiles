# git clone ... && cd nix-config && make

# ultimately this in ~/.config/nix/nix.conf, but we're bootstrappin
NIX := nix --extra-experimental-features "nix-command flakes"

# robot says this is more robust than $(USER)
CUR_USER := $(shell id -un)

# let `nh` run from anywhere
export NH_FLAKE := $(PWD)

default: flake.nix switch

flake.nix: flake.nix.tpl
	sed \
	  -e 's~%%CUR_USER%%~$(CUR_USER)~' \
	  -e 's~%%NH_FLAKE%%~$(NH_FLAKE)~' \
	  flake.nix.tpl > flake.nix

.PHONY: switch build check update gc clean

# `nh` is quite nice, but we have to bootstrap all this first.
switch:
	@if command -v nh >/dev/null 2>&1; then \
		nh home switch; \
	else \
		$(NIX) run home-manager/master -- switch --flake .#$(CUR_USER); \
	fi

build:
	nh home build

check:
	$(NIX) flake check --no-build

update:
	$(NIX) flake update

gc:
	$(NIX) store gc

clean:
	nh clean all
