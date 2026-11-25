# nix-shell -p git -p gnumake
# git clone https://github.com/gulducat/dotfiles.git ~/dotfiles
# cd ~/dotfiles/nix
# make config
# - look at em
# make switch

# robot says this is more robust than $(USER)
CUR_USER := $(shell id -un)
HOST_NAME := $(shell uname -n)

# `nh` is quite nice, but we have to bootstrap all this first.
NH := $(shell command -v nh)
ifneq ("$(NH)","")
RUN_HOME = nh home
RUN_OS = nh os
else
RUN_HOME = nix run home-manager/master -- --flake .#$(CUR_USER)
RUN_OS = sudo nixos-rebuild --flake .
endif
NIXOS_V := $(shell nixos-version 2>/dev/null)

# let `nh` run from anywhere
export NH_FLAKE := $(PWD)

config:
	echo 'experimental-features = nix-command flakes' > config
	mkdir -p ~/.config/nix
	cp config ~/.config/nix/nix.conf
	cp /etc/nixos/*configuration.nix system/

.PHONY: switch build check update gc clean

switch: os-switch home-switch

build: os-build home-build

os-%:
ifneq ("$(NIXOS_V)", "")
	$(RUN_OS) $*
endif

home-%:
	$(RUN_HOME) $*

check:
	nix flake check --no-build

update:
	nix flake update

gc:
	nix store gc

clean:
	nh clean all

