nnoremap <leader>r :source "~/.config/nvim/init.vim" <CR> :echo "config reloaded!"<CR>
nnoremap <leader>tt :ToggleTheme<CR>

set mouse=a

set termguicolors

" 'short message'
set shortmess=aW

set number
" also relative line numbers
set relativenumber

" line width indicators
set colorcolumn=81,101

" https://github.com/junegunn/vim-plug
call plug#begin()

"Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" :Goyo
" https://vimawesome.com/plugin/goyo-vim
Plug 'junegunn/goyo.vim'
let g:goyo_width = "66%"
" :Limelight!!
" https://github.com/junegunn/limelight.vim
Plug 'junegunn/limelight.vim'
"let g:limelight_conceal_ctermfg = 240

" word-wrap, mainly
" https://vimawesome.com/plugin/vim-pencil
Plug 'reedes/vim-pencil'

" :Wordy <tab>
" https://vimawesome.com/plugin/vim-wordy
Plug 'reedes/vim-wordy'

"meh
"Plug 'vim-scripts/scrollfix'
"Plug 'yuttie/comfortable-motion.vim'

" these make errors opening .md files, so not worth it
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'folke/tokyonight.nvim'
Plug 'f-person/auto-dark-mode.nvim'

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'ziglang/zig.vim'

call plug#end()

filetype plugin on

" PencilSoft

"augroup pencil
"  autocmd!
"  autocmd FileType markdown,mkd call pencil#init()
"  autocmd FileType text         call pencil#init()
"augroup END

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>
"nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" golang
nnoremap <C-]> :GoDef<CR>
nnoremap <C-[> :GoDefPop<CR>

"colorscheme tokyonight

"colorscheme PaperColor
"set background=light
colorscheme onedark

"hi Normal ctermbg=NONE guibg=282c34
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=282c34

lua <<EOF
  local auto_dark_mode = require('auto-dark-mode')
  auto_dark_mode.setup({
  	update_interval = 1000,
  	set_dark_mode = function()
  		vim.api.nvim_set_option('background', 'dark')
  		vim.cmd('colorscheme onedark')
  	end,
  	set_light_mode = function()
  		vim.api.nvim_set_option('background', 'light')
  		vim.cmd('colorscheme lunaperche')
  	end,
  })
EOF

" theme toggle, courtesy of IBM bob
" Toggle between two themes
let g:theme_state = 0
command! ToggleTheme call s:ToggleTheme()
function! s:ToggleTheme()
  if g:theme_state == 1
    set background=dark
    colorscheme onedark
    echo 'Theme: onedark'
    let g:theme_state = 0
  else
    set background=light
    colorscheme lunaperche
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

"autocmd! User GoyoEnter Limelight
"autocmd! User GoyoLeave Limelight!

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
