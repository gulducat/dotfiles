{ pkgs, homeDir, ... }:
let
  srt = pkgs.callPackage ./pkgs/srt.nix { };
  hc-install = pkgs.callPackage ./pkgs/hc-install.nix { };
in
{
  home.sessionPath = [
    "${homeDir}/go/bin"
  ];

  home.shellAliases = {
    a = "source ~/.bash_profile";
    ls = "lsd";
    ll = "ls -lh";
    cat = "bat --plain --paging=never";
  };

  programs.bash = {
    enable = true;
    profileExtra = "";
    bashrcExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh # TODO: should not need this.

      if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*.sh; do
          [ -f "$rc" ] && . "$rc"
        done
        unset rc
      fi
    '';
  };

  home.packages = with pkgs; [
      ghostty
      tmux

      # basics
      lsof

      # fancy
      bat
      curlie
      duf
      fastfetch
      fd
      fzf
      gdu
      glow
      jq
      lsd
      procs
      ripgrep # rg
      television # tv

      slides

      # bespoke
      hc-install
      srt
  ];

  # fancy ctrl+r history
  # https://docs.atuin.sh/latest/configuration/config/
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      invert = true;
      show_tabs = false;
      enter_accept = true;
      tmux.enabled = true;
    };
    forceOverwriteSettings = true;
  };

  programs.btop = {
    enable = true;
    # https://github.com/aristocratos/btop#configurability
    settings = {
      color_theme = "TTY";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.lazygit = {
    enable = true;
    shellWrapperName = "lg";
    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    settings = {
      git = {
        branchLogCmd = "git log --graph --color=always --date=relative --pretty=medium {{branchName}} --";
        diffRenderers = [{
          command = "delta --paging=never --detect-dark-light=always --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
        }];
      };
      gui = {
        theme = {
          activeBorderColor = [ "green" ];
          inactiveBorderColor = [ "#777777" ];
        };
        nextScreenMode = "+";
        prevScreenMode = "_";
        nerdFontsVersion = "3";
      };
    };
  };

  # fancy PS1
  programs.starship.enable = true;

  # fancy fuzzy cd
  programs.zoxide.enable = true;

}
