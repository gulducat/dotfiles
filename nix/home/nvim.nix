{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Neovim
  # https://nix-community.github.io/home-manager/options/home-manager/programs/neovim.html
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

      goyo-vim      # https://vimawesome.com/plugin/goyo-vim
      limelight-vim # https://github.com/junegunn/limelight.vim
      # :PencilSoft allows j/k within long wrapped lines.
      vim-pencil    # https://github.com/preservim/vim-pencil
      vim-wordy     # https://github.com/preservim/vim-wordy

      # maybe one day folke will fix this bug:
      # - https://github.com/folke/twilight.nvim/issues/54
      # then I might trust him a little more and also use his
      # - https://github.com/folke/zen-mode.nvim
      # until then, limelight and goyo are reliable.

      indent-blankline-nvim # https://github.com/lukas-reineke/indent-blankline.nvim

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

      # TODO: https://github.com/nvim-tree/nvim-tree.lua/ ? other?
      nerdtree # https://github.com/preservim/nerdtree/

      # https://github.com/nvim-telescope/telescope.nvim
      telescope-nvim
      plenary-nvim # core dependency
      telescope-fzf-native-nvim
      telescope-ui-select-nvim

      # code

      # vim.lsp - :help lsp
      nvim-lspconfig # https://github.com/neovim/nvim-lspconfig
      lazydev-nvim # https://github.com/folke/lazydev.nvim

      tiny-inline-diagnostic-nvim # https://github.com/rachartier/tiny-inline-diagnostic.nvim

      blink-cmp # https://github.com/saghen/blink.cmp

      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim

    ];
  };

}
