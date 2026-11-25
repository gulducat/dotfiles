# home-manager only (non-nixos):
# make switch

# fresh nixos install:
# nix-shell -p git -p gnumake
# git clone https://github.com/gulducat/dotfiles.git ~/dotfiles
# cd ~/dotfiles/nix
# make config
# - look at em
# make switch

# `nh` is quite nice, but we have to bootstrap all this first.
NH := $(shell command -v nh)
ifneq ("$(NH)","")
RUN_HOME = nh home
RUN_OS = nh os
# let `nh` run from anywhere
export NH_FLAKE := $(PWD)
else
RUN_HOME = nix run home-manager/master -- --flake .
RUN_OS = sudo nixos-rebuild --flake .
endif

config:
	echo 'experimental-features = nix-command flakes' > config
	mkdir -p ~/.config/nix
	cp config ~/.config/nix/nix.conf
	cp /etc/nixos/*configuration.nix system/

.PHONY: switch build check update gc clean

switch: os-switch home-switch

build: os-build home-build

os-%:
ifneq ("$(shell nixos-version 2>/dev/null)", "")
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

