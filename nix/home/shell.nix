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

      # basics
      lsof
      unzip

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

  programs.tmux = {
    enable = true;

    # writes config to ~/.config/tmux/
    # https://nix-community.github.io/home-manager/options/home-manager/programs/tmux.html0
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";

	# load a synlink'd conf for quickly iterating changes
    extraConfig = "source-file ~/.config/tmux/bespoke.conf"; # files/tmux.conf

    # plugins
    sensibleOnTop = true; # https://github.com/tmux-plugins/tmux-sensible
    # https://search.nixos.org/packages?channel=unstable&query=tmuxPlugins.
    plugins = with pkgs.tmuxPlugins; [
      #sensible
      pain-control # https://github.com/tmux-plugins/tmux-pain-control
      resurrect    # https://github.com/tmux-plugins/tmux-resurrect
      #continuum   # TODO? needs status-right... https://github.com/tmux-plugins/tmux-continuum

      tmux-fzf # prefix-F fuzzy tmux functions: https://github.com/sainnhe/tmux-fzf
      { # prefix-? fuzzy scrollback search: https://github.com/roosta/tmux-fuzzback
        plugin = fuzzback;
        extraConfig = ''
        set -g @fuzzback-popup 1
        set -g @fuzzback-popup-size '80%'
        '';
      }
      {
        plugin = extrakto; # prefix-tab fuzzy-fill text on screen: https://github.com/laktak/extrakto
        extraConfig = ''
        set -g @extrakto_popup_size "60%" # default 90%
        set -g @extrakto_fzf_layout "reverse" # top-down
        '';
      }

      { # https://github.com/niksingh710/minimal-tmux-status
        plugin = minimal-tmux-status;
        extraConfig = ''
        set -g @minimal-tmux-indicator true
        set -g @minimal-tmux-indicator-str "   "
        set -g @minimal-tmux-status "top"
        set -g @minimal-tmux-right false
        #set -g @minimal-tmux-left false
        set -g @minimal-tmux-use-arrow true
        set -g @minimal-tmux-right-arrow ""
        set -g @minimal-tmux-left-arrow ""
        '';
      }
    ];
	# TODO: tmuxp.enable? https://github.com/tmux-python/tmuxp
  };

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
