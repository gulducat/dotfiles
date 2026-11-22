--[[ fancy hotkey cheat-sheet:

\? -- :Cheatsheet -- lots of cheats

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

-----------
-- input --
-----------

vim.opt.mouse = 'a'

vim.opt.clipboard = 'unnamedplus' -- always use system clipboard for yank/put

-- custom shortcuts

-- <leader> = \ , so e.g. "\r" will reload this config
vim.keymap.set('n', '<leader>r', function()
  vim.cmd('luafile ~/.config/nvim/lua/bespoke.lua')
  vim.notify('bespoke nvim config reloaded!')
end, { desc = 'Reload config' })

vim.keymap.set('n', '<C-t>', function() vim.cmd('tabnew') end, { desc = 'New tab' })

vim.keymap.set('n', '<leader>w', function() vim.cmd.Goyo() end, { desc = 'Writer (zen) mode' })

vim.keymap.set('n', '<leader>t', function() vim.cmd('NvimTreeToggle') end, { desc = 'File tree' })

local scope = require('telescope.builtin')
vim.keymap.set('n', '<leader>f.', scope.builtin, { desc = 'Telescope menu' })
vim.keymap.set('n', '<leader>fs', scope.treesitter, { desc = 'Telescope symbols' })
vim.keymap.set('n', '<leader>ff', scope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fo', scope.oldfiles, { desc = 'Telescope oldfiles (recent)' })
vim.keymap.set('n', '<leader>fc', scope.git_status, { desc = 'Telescope changes (git status)' })
vim.keymap.set('n', '<leader>fg', scope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', scope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fj', scope.jumplist, { desc = 'Telescope jumplist (cursor history)' })
vim.keymap.set('n', '<leader>fh', scope.help_tags, { desc = 'Telescope help tags' })

local git = require('gitsigns')
vim.keymap.set('n', '<leader>g.', vim.cmd.Gitsigns, { desc = 'gitsigns menu' })
vim.keymap.set('n', '<leader>gb', git.blame, { desc = 'git blame' })
vim.keymap.set('n', '<leader>gd', git.diffthis, { desc = 'git diff' })
vim.keymap.set('n', '<leader>gl', git.toggle_linehl, { desc = 'toggle inline diff' })
vim.keymap.set('n', '<leader>gh', git.preview_hunk_inline, { desc = 'preview hunk' })
vim.keymap.set('n', '<leader>gn', function() git.nav_hunk('next') end, { desc = 'next hunk' })
vim.keymap.set('n', '<leader>gp', function() git.nav_hunk('prev') end, { desc = 'prev hunk' })
vim.keymap.set('n', '<leader>gs', function() git.select_hunk() git.stage_hunk() end, { desc = 'stage/unstage hunk' })
vim.keymap.set('v', '<leader>gs', git.stage_hunk, { desc = 'stage/unstage hunk' })
vim.keymap.set('n', '<leader>gr', git.reset_hunk, { desc = 'reset hunk' })

-------------
-- display --
-------------

vim.opt.termguicolors = true
vim.opt.shortmess = 'aW' -- 'short message'
vim.opt.winborder = 'solid' -- little pop-up modals

vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '81,101' -- line length indicators
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevel = 2

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- splash screen

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

----------
-- code --
----------

-- language servers
vim.lsp.enable('nixd')
vim.lsp.enable('ruff') -- python
vim.lsp.enable('ts_ls') -- typescript
vim.lsp.enable('rust_analyzer')

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

vim.cmd([[ " old school, kinda hard to replicate in lua

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" auto-save modified buffer during idle after 'updatetime'
" has elapsed (default 4 sec)
autocmd CursorHoldI,CursorHold * silent! update

]])
