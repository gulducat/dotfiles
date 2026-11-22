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

      alpha-nvim # splash screen: https://github.com/goolord/alpha-nvim

      { # theme
        # https://github.com/olimorris/onedarkpro.nvim/
        plugin = onedarkpro-nvim;
        config = ''
        -- auto light/dark mode
        local function set_colorscheme()
          vim.cmd.colorscheme(
            vim.o.background == "light" and "github_light" or "onedark_vivid"
          )
        end
        set_colorscheme()
        vim.api.nvim_create_autocmd("OptionSet", {
          pattern = "background",
          callback = set_colorscheme,
          nested = true, -- do subsequent theming, like indent-blankline
        })
        '';
      }
      github-nvim-theme # https://github.com/projekt0n/github-nvim-theme
      #papercolor-theme-slim # https://github.com/pappasam/papercolor-theme-slim/

      { plugin = cheatsheet-nvim;
        # https://github.com/sudormrfbin/cheatsheet.nvim/
        config = "require('cheatsheet').setup()";
      }

      limelight-vim # https://github.com/junegunn/limelight.vim
      { # https://vimawesome.com/plugin/goyo-vim
        plugin = goyo-vim;
        config = ''
        vim.g.goyo_width = 80
        vim.g.goyo_height = 95
        vim.g.limelight_paragraph_span = 1
        vim.api.nvim_create_autocmd('User', { pattern = 'GoyoEnter',
          callback = function()
            vim.cmd.Limelight()
            vim.opt.showmode = false
            vim.opt.signcolumn = 'no'
            vim.system({'tmux', 'set-option', 'status', 'off'})
            require('ibl').update({enabled = false})
          end,
        })
        vim.api.nvim_create_autocmd('User', { pattern = 'GoyoLeave',
          callback = function()
            vim.cmd(':Limelight!')
            vim.opt.showmode = true
            vim.opt.signcolumn = 'auto'
            vim.system({'tmux', 'set-option', 'status', 'on'})
            require('ibl').update({enabled = true})
          end,
        })
        '';
      }
      { # https://github.com/preservim/vim-pencil
        # :PencilSoft allows j/k within long wrapped lines.
        # attaching other writing-related things here, too.
        plugin = vim-pencil;
        config = ''
        -- clean layout for writing prose
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'text', 'markdown' },
          callback = function()
            vim.cmd('PencilSoft')
            vim.opt.number = false
            vim.opt.relativenumber = false
            vim.opt.colorcolumn = '0'
            vim.opt.foldmethod = 'manual'
          end
        })
        '';
      }
      vim-wordy     # https://github.com/preservim/vim-wordy

      # maybe one day folke will fix this bug:
      # - https://github.com/folke/twilight.nvim/issues/54
      # then I might trust him a little more and also use his
      # - https://github.com/folke/zen-mode.nvim
      # until then, limelight and goyo are reliable.

      { # hotkey help pop-up: https://github.com/folke/which-key.nvim
        plugin = which-key-nvim;
        config = "require('which-key').setup({ delay = 800 })";
      }

      { # https://github.com/lukas-reineke/indent-blankline.nvim
        plugin = indent-blankline-nvim;
        config = "require('ibl').setup()";
      }

      { # auto-close brackets, etc: https://github.com/windwp/nvim-autopairs
        plugin = nvim-autopairs; 
        config = "require('nvim-autopairs').setup()";
      }

      # treesitter https://github.com/nvim-treesitter/nvim-treesitter
      # parsers:
      # curl -Ls https://github.com/NixOS/nixpkgs/raw/refs/heads/nixos-26.05/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix | awk '/buildGrammar/ {print$1}'
    {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.nix p.lua
          p.markdown
          p.bash p.make
          p.diff p.git_config
          p.css p.html p.javascript
          p.json p.toml p.yaml
          p.go p.python p.rust p.typescript
          p.dockerfile
          p.godot_resource
        ]));
        config =  ''
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'nix', 'lua', 'json', 'go', 'py', 'sh', 'bash', 'rs' },
          callback = function()
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.treesitter.start()
         end,
        })
        '';
      }

      # navigation

      { # edit filenames in a buffer # https://github.com/stevearc/oil.nvim
        plugin = oil-nvim;
        config = "require('oil').setup({})";
      }

      #nerdtree # https://github.com/preservim/nerdtree/
      { # https://github.com/nvim-tree/nvim-tree.lua/
        plugin = nvim-tree-lua;
        # based on @Lutalli: https://github.com/nvim-tree/nvim-tree.lua/wiki/Showcases
        config = ''
        require('nvim-tree').setup({
          view = { cursorline = false },
          renderer = {
            icons = {
              show = { hidden = true },
              git_placement = "after",
              symlink_arrow = " -> ",
              glyphs = {
                folder = {
                  arrow_closed = " ",
                  arrow_open = " ",
                  default = "",
                  open = "",
                  empty = "",
                  empty_open = "",
                  symlink = "",
                  symlink_open = ""
                },
                default = "󱓻",
                symlink = "󱓻",
                bookmark = "",
                modified = "",
                hidden = "󱙝",
                git = {
                  unstaged = "×",
                  staged = "",
                  unmerged = "󰧾",
                  untracked = "",
                  renamed = "",
                  deleted = "",
                  ignored = "∅"
                }
              }
            }
          },
          filters = { git_ignored = false },
          sync_root_with_cwd = true
        })
        '';
	  }

      { plugin = telescope-nvim;
        # https://github.com/nvim-telescope/telescope.nvim
        # https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
        # https://github.com/nvim-telescope/telescope-ui-select.nvim
        config = ''
        local scope = require('telescope')
        scope.setup({
          defaults = {
            prompt_prefix = '❯ ',
            selection_caret = '➜ ',
            sorting_strategy = 'ascending',
            layout_config = {
              prompt_position = 'top',
            },
            borderchars = { "─", "", "", "", "", "", "", "" },
          },
          extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown {} }
          }
        })
        scope.load_extension('ui-select')
        '';
      }
      plenary-nvim # core dependency
      telescope-fzf-native-nvim
      telescope-ui-select-nvim

      # code

      # vim.lsp - :help lsp
      nvim-lspconfig # https://github.com/neovim/nvim-lspconfig
      lazydev-nvim # https://github.com/folke/lazydev.nvim

      { # https://github.com/rachartier/tiny-inline-diagnostic.nvim
        plugin = tiny-inline-diagnostic-nvim;
        config = ''
        require('tiny-inline-diagnostic').setup({
          preset = 'powerline',
          options = {
            multilines = {
              enabled = true,
              always_show = true,
              severity = { vim.diagnostic.severity.ERROR },
            },
            show_source = {
              enabled = true,
            },
          },
        })
        -- Disable Neovim's default virtual text diagnostics
        vim.diagnostic.config({ virtual_text = false })
        '';
      }

      { # smol completion pop-up: https://github.com/saghen/blink.cmp
        plugin = blink-cmp;
        config = ''
        require('blink-cmp').setup({
          -- not when i'm writing prose, please.
          enabled = function() return not vim.tbl_contains({ 'text', 'markdown' }, vim.bo.filetype) end,
          -- https://cmp.saghen.dev/configuration/general.html
          completion = {
            list = { selection = { preselect = true, auto_insert = false } },
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            ghost_text = { enabled = true },
          },
          signature = { enabled = true },
        })
        '';
      }

      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim

    ];
  };

}
