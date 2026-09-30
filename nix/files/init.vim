" <leader> = \ , so "\r" will reload this config
nnoremap <leader>r :source "~/.config/nvim/init.vim" <CR> :echo "config reloaded!"<CR>
nnoremap <leader>tt :ToggleTheme <CR>
nnoremap <leader>w :Goyo <CR>
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

"Plug 'joshdick/onedark.vim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'folke/tokyonight.nvim'
"Plug 'projekt0n/github-nvim-theme'
Plug 'f-person/auto-dark-mode.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdtree' " https://github.com/preservim/nerdtree

"Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

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
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" :Pencil<tab> -- word-wrap, mainly, if not using vim-pandoc
"Plug 'reedes/vim-pencil' " https://vimawesome.com/plugin/vim-pencil

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'ziglang/zig.vim'

call plug#end()

" PencilSoft
"augroup pencil
"  autocmd!
"  autocmd FileType markdown,mkd call pencil#init()
"  autocmd FileType text         call pencil#init()
"augroup END

"hi Normal ctermbg=NONE guibg=282c34
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=282c34

colorscheme onedark_vivid
lua <<EOF
  local auto_dark_mode = require('auto-dark-mode')
  auto_dark_mode.setup({
  	update_interval = 1000,
  	set_dark_mode = function()
  		vim.api.nvim_set_option('background', 'dark')
  		vim.cmd('colorscheme onedark_vivid')
  	end,
  	set_light_mode = function()
  		vim.api.nvim_set_option('background', 'light')
  		vim.cmd('colorscheme PaperColor')
  	end,
  })
EOF

" theme toggle, courtesy of IBM bob
let g:theme_state = 0
command! ToggleTheme call s:ToggleTheme()
function! s:ToggleTheme()
  if g:theme_state == 1
    set background=dark
    colorscheme onedark
    echo 'Theme: onedark_vivid'
    let g:theme_state = 0
  else
    set background=light
    colorscheme PaperColor
    echo 'Theme: PaperColor (light)'
    let g:theme_state = 1
  endif
endfunction

lua << EOF
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 300,
  },
})
EOF

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
