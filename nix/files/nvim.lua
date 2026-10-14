-- shortcuts

-- <leader> = \ , so e.g. "\r" will reload this config
vim.keymap.set('n', '<leader>r', function() vim.cmd([[
  source ~/.config/nvim/lua/bespoke.lua
  echo 'config reloaded!'
]])end)

vim.keymap.set('n', '<leader>w', function() require('zen-mode').toggle() end)

local scope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', scope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', scope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', scope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', scope.help_tags, { desc = 'Telescope help tags' })

-- display

-- auto light/dark mode
local function set_colorscheme()
  vim.cmd.colorscheme(
    vim.o.background == "light"
    and "PaperColorSlimLight"
    or "onedark_vivid"
  )
end
set_colorscheme()
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = set_colorscheme,
})

vim.o.linebreak = true;

-- old school
vim.cmd([[
" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

set mouse=a

" always use system clipboard for yank/put
set clipboard+=unnamedplus

set termguicolors

set shortmess=aW " 'short message'

set number
set relativenumber

set colorcolumn=81,101 " line length indicators

filetype plugin on
augroup clean_text
  autocmd!
  autocmd FileType markdown,text
  \ set colorcolumn=0
  \ | set nonumber
  \ | set norelativenumber
augroup END

" auto-save modified buffer during idle after 'updatetime'
" has elapsed (default 4 sec)
autocmd CursorHoldI,CursorHold * silent! update

" https://github.com/junegunn/vim-plug
call plug#begin()

" youtube: rethinking neovim as a tool for writers
":set spell"

"Plug 'tpope/vim-fugitive'

"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" :Goyo
Plug 'junegunn/goyo.vim' " https://vimawesome.com/plugin/goyo-vim
let g:goyo_width = 85
let g:goyo_height = 95

" :Limelight!!
Plug 'junegunn/limelight.vim' " https://github.com/junegunn/limelight.vim
"let g:limelight_conceal_ctermfg = 240

" :Wordy <tab>
Plug 'reedes/vim-wordy' " https://vimawesome.com/plugin/vim-wordy

"meh
"Plug 'vim-scripts/scrollfix'
"Plug 'yuttie/comfortable-motion.vim'

" needs pandoc installed
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'ziglang/zig.vim'

call plug#end()

"hi Normal ctermbg=NONE guibg=282c34
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=282c34

augroup golang
  autocmd!
  autocmd FileType go
  \ set foldmethod=syntax
  \ | nnoremap <C-]> :GoDef<CR>
  \ | nnoremap <C-[> :GoDefPop<CR>
augroup END

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
"autocmd! User GoyoEnter set foldmethod=manual

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
