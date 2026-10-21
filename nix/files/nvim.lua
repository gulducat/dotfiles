-- shortcuts

-- <leader> = \ , so e.g. "\r" will reload this config
vim.keymap.set('n', '<leader>r', function()
  vim.cmd('luafile ~/.config/nvim/lua/bespoke.lua')
  vim.notify('config reloaded!')
end)

vim.keymap.set('n', '<leader>tn', function() vim.cmd('tabnew') end)

vim.keymap.set('n', '<leader>w', function() vim.cmd.Goyo() end)

vim.keymap.set('n', '<C-n>', function() vim.cmd('NERDTree') end)
vim.keymap.set('n', '<C-t>', function() vim.cmd('NERDTreeToggle') end)
vim.keymap.set('n', '<C-f>', function() vim.cmd('NERDTreeFind') end)

local scope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', scope.find_files, { desc = 'Telescope find files' })
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

-- writer mode:
-- remember: `:set spell`
-- - youtube: rethinking neovim as a tool for writers
vim.g.goyo_width = 80
vim.g.goyo_height = 95
vim.g.limelight_paragraph_span = 1
vim.api.nvim_create_autocmd('User', { pattern = 'GoyoEnter',
  callback = function()
    vim.cmd.Limelight()
    vim.opt.signcolumn = 'no'
    vim.system({'tmux', 'set-option', 'status', 'off'})
  end,
})
vim.api.nvim_create_autocmd('User', { pattern = 'GoyoLeave',
  callback = function()
    vim.cmd(':Limelight!')
    vim.opt.signcolumn = 'auto'
    vim.system({'tmux', 'set-option', 'status', 'on'})
  end,
})

vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '81,101' -- line length indicators
vim.opt.foldmethod = 'syntax'

-- cleaner formatting for writing prose
vim.api.nvim_create_autocmd('FileType', { pattern = 'text,markdown',
  callback = function()
    vim.cmd('PencilSoft')
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = '0'
    vim.opt.foldmethod = 'manual'
  end
})

-- code

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
    local params = vim.lsp.util.make_range_params()
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

" pandoc folds are annoyingly collapsed-by-default,
" and really I want to make manual folds, anyway.
let g:pandoc#modules#disabled = ["folding"]

" un-highlight pandoc
"hi! link pandocAtxHeader markdownH1
"hi! link pandocBlockQuote markdownBlockquote
"hi! link pandocCiteAnchor Operator
"hi! link pandocCiteKey pandocReferenceLabel
"hi! link pandocDefinitionBlockMark Operator
"hi! link pandocEmphasis markdownItalic
"hi! link pandocFootnoteID pandocReferenceLabel
"hi! link pandocFootnoteIDHead markdownLinkDelimiter
"hi! link pandocFootnoteIDTail pandocFootnoteIDHead
"hi! link pandocGridTableDelims pandocTableDelims
"hi! link pandocGridTableHeader pandocTableDelims
"hi! link pandocOperator Operator
"hi! link pandocPipeTableDelims pandocTableDelims
"hi! link pandocReferenceDefinition pandocReferenceLabel
"hi! link pandocReferenceLabel markdownLinkText
"hi! link pandocReferenceURL markdownUrl
"hi! link pandocSimpleTableHeader pandocAtxHeader
"hi! link pandocStrong markdownBold
"hi! link pandocTableHeaderWord pandocAtxHeader
"hi! link pandocUListItemBullet Operator

"set foldmethod=manual
]])
