{ pkgs, homeDir, ... }:
{
  home.shellAliases = {
    # code review: https://github.com/oxidecomputer/skepsis
    sk = "npx @oxide/skepsis";
  };

  home.packages = with pkgs; [
    # --- git / github / dev workflow ---
    delta # git-delta
    diffnav
    gh
    gh-dash
    gh-enhance
    hunk

    # --- languages / toolchains ---
    gcc
    nodejs
    pnpm
    # `go` down below
    gopls
    lua-language-server
    nixd
    ruff # python linter / language server
    typescript-language-server
    #uv
    #godot

    cargo rustc rust-analyzer

    # --- linting / scripting ---
    shellcheck
    #actionlint
    #act
  ];

  #programs.pnpm.enable = true;

  programs.go = {
    enable = true;
    env = {
      GOPATH = [ "${homeDir}/go" ];
      GOPRIVATE = [
        "github.com/hashicorp"
      ];
    };
    telemetry.mode = "local";
  };

  # https://wiki.nixos.org/wiki/Zed
  programs.zed-editor = {
   enable = true;
   extraPackages = with pkgs; [
     nil nixd
     lua-language-server
     go gopls delve
   ];
   # user settings in files/zed/
  };
  #programs.nix-ld = {
  #  enable = true;
  #  libraries = [ pkgs.zlib pkgs.openssl ];
  #};
}
