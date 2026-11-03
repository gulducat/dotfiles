--[[ fancy hotkey cheat-sheet:

:help gc -- comment/uncomment lines
:help > -- indent line(s)

:help vim.lsp
 - "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
 - "gri" is mapped to vim.lsp.buf.implementation()
 - "grn" is mapped to vim.lsp.buf.rename()
 - "grr" is mapped to vim.lsp.buf.references()
 - "grt" is mapped to vim.lsp.buf.type_definition()
 - "grx" is mapped to vim.lsp.codelens.run()
 - "gO" is mapped to vim.lsp.buf.document_symbol()
 - "K" is mapped to vim.lsp.buf.hover()
 - CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
 - CTRL-X CTRL-O is mapped to vim.lsp.omnifunc()

:help vim.diagnostic
 - `]d` jumps to the next diagnostic in the buffer.
 - `[d` jumps to the previous diagnostic in the buffer.
 - `]D` jumps to the last diagnostic in the buffer.
 - `[D` jumps to the first diagnostic in the buffer.
 - `<C-w>d` shows diagnostic at cursor in a floating window.fault|

]]

local dash = require("alpha.themes.dashboard")
dash.section.header.val = {
-- inspired by: https://www.asciiart.eu/art/3fc3a30e2bc9a375
[[           -   _-                        ]],
[[         (         )                     ]],
[[     ,    (     ))   )                   ]],
[[   (                   )       /\        ]],
[[  (_      `___ -_   _-         \/        ]],
[[                               ' +       ]],
[[                              '   +      ]],
[[                             '   +       ]],
[[                           '      +      ]],
[[                         '          +    ]],
[[                       '               + ]],
[[                     '                   ]],
[[                  '                      ]],
[[               '                         ]],
[[            '                            ]],
[[         '                               ]],
[[  c  .'                                  ]],
[[ <\\/                                    ]],
[[  |\                                     ]],
[[ / /                         ₙₑₒᵥᵢₘ      ]],
}
dash.section.buttons.val = {
  -- https://www.nerdfonts.com/cheat-sheet
  dash.button("n",  " " .. " New",     ":Alpha <CR>"),
  dash.button("fo", "󰥔 " .. " Recent",  ":Telescope oldfiles <CR>"),
  dash.button("fc", "󰊢 " .. " Changes", ":Telescope git_status <CR>"),
  dash.button("ff", " " .. " Files",   ":Telescope find_files <CR>"),
  dash.button("fg", "󰍉 " .. " Words",   ":Telescope live_grep <CR>"),
  dash.button("t",  "󰙅 " .. " Tree",    ":NvimTreeToggle <CR>"),
  dash.button("q",  "󰜎 " .. " Quit",    ":q <CR>"),
  --dash.button("ar", " " .. " Redraw",  ":AlphaRedraw <CR>"),
}
for _, btn in pairs(dash.section.buttons.val) do
  btn.opts.width = 22 -- narrower than default (50)
  btn.opts.cursor = -2 -- cursor to the left of menu items
end
dash.section.buttons.opts.spacing = 0 -- no blank line between menu items
dash.config.layout = {
  { type = "padding", val = math.max(1, math.min(20, -- clamp between 1 and 20
    vim.api.nvim_win_get_height(0) - 40 -- win height minus ~size of art+menu
  ))},
  dash.section.header,
  { type = "padding", val = 5 },
  dash.section.buttons,
}
require("alpha").setup(dash.config)

-- custom shortcuts

-- <leader> = \ , so e.g. "\r" will reload this config
vim.keymap.set('n', '<leader>r', function()
  vim.cmd('luafile ~/.config/nvim/lua/bespoke.lua')
  vim.notify('config reloaded!')
end, { desc = 'Reload config' })

vim.keymap.set('n', '<C-t>', function() vim.cmd('tabnew') end, { desc = 'New tab' })

vim.keymap.set('n', '<leader>w', function() vim.cmd.Goyo() end, { desc = 'Writer (zen) mode' })

vim.keymap.set('n', '<leader>t', function() vim.cmd('NvimTreeToggle') end, { desc = 'File tree' })

local scope = require('telescope.builtin')
vim.keymap.set('n', '<leader>fs', scope.treesitter, { desc = 'Telescope symbols' })
vim.keymap.set('n', '<leader>ff', scope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fo', scope.oldfiles, { desc = 'Telescope oldfiles (recent)' })
vim.keymap.set('n', '<leader>fg', scope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', scope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', scope.help_tags, { desc = 'Telescope help tags' })

-- display

vim.opt.winborder = 'solid' -- pop-up modals

-- auto light/dark mode
local function set_colorscheme()
  vim.cmd.colorscheme(
    vim.o.background == "light" and "PaperColorSlimLight" or "onedark_vivid"
  )
end
set_colorscheme()
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = set_colorscheme,
})

-- indent-blankline indicators
local ibl = require('ibl')
ibl.setup()

-- writer mode:
-- remember: `:set spell`
-- - youtube: rethinking neovim as a tool for writers
vim.g.goyo_width = 80
vim.g.goyo_height = 95
vim.g.limelight_paragraph_span = 1
vim.api.nvim_create_autocmd('User', { pattern = 'GoyoEnter',
  callback = function()
    vim.cmd.Limelight()
    vim.opt.showmode = false
    vim.opt.signcolumn = 'no'
    vim.system({'tmux', 'set-option', 'status', 'off'})
    ibl.update({enabled = false})
  end,
})
vim.api.nvim_create_autocmd('User', { pattern = 'GoyoLeave',
  callback = function()
    vim.cmd(':Limelight!')
    vim.opt.showmode = true
    vim.opt.signcolumn = 'auto'
    vim.system({'tmux', 'set-option', 'status', 'on'})
    ibl.update({enabled = true})
  end,
})

vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '81,101' -- line length indicators
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevel = 2
vim.opt.tabstop = 4

-- cleaner formatting for writing prose
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

require('nvim-tree').setup({
  -- based on @Lutalli: https://github.com/nvim-tree/nvim-tree.lua/wiki/Showcases
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

require('oil').setup({})

-- code

-- treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'nix', 'lua', 'json', 'go', 'py', 'sh', 'bash', 'rs' },
  callback = function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.treesitter.start()
 end,
})

-- lil completion pop-up
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
vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics

require('telescope').setup({
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown {} }
  }
})
require('telescope').load_extension('ui-select')

-- language servers
vim.lsp.enable('nixd')
vim.lsp.enable('ruff') -- python
vim.lsp.enable('ts_ls') -- typescript
vim.lsp.enable('rust_analyzer')

require('nvim-autopairs').setup()

-- neovim + lua for editing this very file
require('lazydev').setup()
vim.lsp.enable('lua_ls')

-- go
-- https://go.dev/gopls/settings
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      semanticTokens = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    }
  }
})
vim.lsp.enable('gopls')

-- https://go.dev/gopls/editor/vim#a-hrefneovim-imports-idneovim-importsimports-and-formattinga
-- goimports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params(0, "utf-32")
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

-- old school
vim.cmd([[

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

set mouse=a

" always use system clipboard for yank/put
set clipboard+=unnamedplus

set termguicolors

set shortmess=aW " 'short message'

" auto-save modified buffer during idle after 'updatetime'
" has elapsed (default 4 sec)
autocmd CursorHoldI,CursorHold * silent! update

"hi Normal ctermbg=NONE guibg=282c34
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=282c34
]])
