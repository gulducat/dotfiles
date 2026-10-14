{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Neovim
  # https://nix-community.github.io/home-manager/options/home-manager/programs/neovim.html
  # TODO: https://cocnvim.com ??
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # config-links.nix:
    # files/nvim.lua -> ~/.config/nvim/lua/bespoke.lua
    initLua = "require('bespoke')";

    extraPackages = [ pkgs.tree-sitter ];
    plugins = with pkgs.vimPlugins; [

      # display

      onedarkpro-nvim # https://github.com/olimorris/onedarkpro.nvim/
      papercolor-theme-slim # https://github.com/pappasam/papercolor-theme-slim/

      { # https://github.com/preservim/vim-pencil
        plugin = vim-pencil;
        # TODO: lua?
        config = ''vim.cmd([[
        augroup pencil
          autocmd!
          autocmd FileType markdown,mkd call pencil#init()
          autocmd FileType text         call pencil#init()
        augroup END
        ]])
        '';
      }

      twilight-nvim # https://github.com/folke/twilight.nvim
      { # https://github.com/folke/zen-mode.nvim
        plugin = zen-mode-nvim;
        config = ''
        require('zen-mode').setup({
          window = {
            backdrop = 1,
            width = .55,
            height= .85,
            options = {
              signcolumn = "no",
              number = false,
              relativenumber = false,
              cursorline = false,
            },
          },
          plugins = {
            tmux = { enabled = true },
            -- global vim options
            options = {
              enabled = true,
              ruler = false,
              showcmd = false,
              laststatus = 0,
            },
          },
        })
        '';
      }

      # treesitter https://github.com/nvim-treesitter/nvim-treesitter
      # parsers:
      # curl -Ls https://github.com/NixOS/nixpkgs/raw/refs/heads/nixos-26.05/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix | awk '/buildGrammar/ {print$1}'
      (nvim-treesitter.withPlugins (p: [
        p.nix p.lua
        p.markdown
        p.bash p.make
        p.diff p.git_config
        p.css p.html p.javascript
        p.json p.toml p.yaml
        p.go p.python p.rust p.typescript
        p.dockerfile
        p.godot_resource
      ]))

      # navigation

      nerdtree # https://github.com/preservim/nerdtree/

      # https://github.com/nvim-telescope/telescope.nvim
      telescope-nvim plenary-nvim

      # code

      # TODO: https://github.com/hrsh7th/nvim-cmp ??

      vim-go # https://github.com/fatih/vim-go

      { # https://github.com/lewis6991/gitsigns.nvim
        plugin = gitsigns-nvim;
        #config = ''
        #require('gitsigns').setup({
        #  current_line_blame = true,
        #  current_line_blame_opts = {
        #    delay = 300,
        #  },
        #})
        #'';
      }

    ];
  };

}
