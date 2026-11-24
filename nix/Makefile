# nix-shell -p git -p gnumake
# git clone https://github.com/gulducat/dotfiles.git ~/dotfiles
# cd ~/dotfiles/nix
# rm flake.nix system/hardware-configuration.nix
# git update-index --assume-unchanged \
#   flake.nix system/hardware-configuration.nix
# make
# nh os switch

# robot says this is more robust than $(USER)
CUR_USER := $(shell id -un)
HOST_NAME := $(shell uname -n)

# let `nh` run from anywhere
export NH_FLAKE := $(PWD)

default: nix-config flake.nix switch

nix-config:
	echo 'experimental-features = nix-command flakes' > nix-config
	mkdir -p ~/.config/nix
	cp nix-config ~/.config/nix/nix.conf

flake.nix: flake.nix.tpl
	sed \
	  -e 's~%%HOST_NAME%%~$(HOST_NAME)~' \
	  -e 's~%%CUR_USER%%~$(CUR_USER)~' \
	  -e 's~%%NH_FLAKE%%~$(NH_FLAKE)~' \
	  flake.nix.tpl > flake.nix

.PHONY: switch build check update gc clean

# `nh` is quite nice, but we have to bootstrap all this first.
switch:
	@if command -v nh >/dev/null 2>&1; then \
		nh home switch; \
	else \
		nix run home-manager/master -- switch --flake .#$(CUR_USER); \
	fi

build:
	home-manager --flake . build

check:
	nix flake check --no-build

update:
	nix flake update

gc:
	nix store gc

clean:
	nh clean all

system/hardware-configuration.nix:
	nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
