set mouse=a

set termguicolors

" 'short message'
set shortmess=aW

" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" :Goyo
" https://vimawesome.com/plugin/goyo-vim
Plug 'junegunn/goyo.vim'
let g:goyo_width = 66
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

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'folke/tokyonight.nvim'
Plug 'f-person/auto-dark-mode.nvim'

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'ziglang/zig.vim'

call plug#end()

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"colorscheme tokyonight
"colorscheme PaperColor
"colorscheme onedark
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
  		vim.cmd('colorscheme PaperColor')
  	end,
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
