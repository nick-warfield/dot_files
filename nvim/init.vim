set showmatch
set ignorecase
set hlsearch
set tabstop=4
set softtabstop=4
set noexpandtab
set shiftwidth=4
set autoindent
set nonumber
set wildmode=longest,list
set autoread
set mouse=a
set foldmethod=syntax

" for vimwiki plugin
set nocompatible
filetype plugin on
syntax on

noremap <A-[> <C-[>
tnoremap <A-[> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>
nnoremap <silent> <Space> za
nnoremap <C-J> <C-D> M
nnoremap <C-K> <C-U> M

" Plugins go here

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'airblade/vim-gitgutter'             " show git changes in file
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'                " tree view of files
Plug 'majutsushi/tagbar'                  " make ctags

Plug 'neovim/pynvim'

Plug 'w0rp/ale'							  " linter
Plug 'octol/vim-cpp-enhanced-highlight'   " additional c++ highlighting
Plug 'derekwyatt/vim-fswitch'

Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'

"Plug 'jceb/vim-orgmode'
Plug 'vimwiki/vimwiki'
Plug 'itchyny/calendar.vim'

" Language Support
Plug 'xuhdev/vim-latex-live-preview'
Plug 'plasticboy/vim-markdown'
Plug 'keith/swift.vim'
Plug 'mlr-msft/vim-loves-dafny'

" Plugins stop here
call plug#end()

let g:python3_host_prog='/usr/bin/python'

autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

let g:ale_linters = { 'cpp': ['g++'], 'c': ['gcc'], }
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -Iinclude -isystem lib'
let g:ale_set_highlights = 0

let g:rust_recommended_style = 0
let g:rust_fold = 1

let g:livepreview_previewer = 'qpdfview'

set signcolumn=yes
let g:gitgutter_set_sign_backgrounds = 1
highlight clear SignColumn

" this is also linting, which is giving me bad warnings/errors
"call neomake#configure#automake('nw', 1000)

nnoremap <F5> :!make run<CR>
nnoremap <F6> :!make test<CR>
nnoremap <F7> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>
nnoremap <F9> zR
nnoremap <F10> zM
nnoremap <F11> :set nu!<CR>

command -nargs=0 T set nonu | exe "te" | exe "startinsert"
command -nargs=0 TLeft vs | set nonu | exe "te" | exe "startinsert"
command -nargs=0 TRight vs | exe "normal! <C-w>l" | set nonu | exe "te" | exe "startinsert"
command -nargs=0 TUp split | set nonu | exe "te" | exe "startinsert"
command -nargs=0 TDown split | exe "normal! <C-w>j" | set nonu | exe "te" | exe "startinsert"
command -nargs=0 TTab tabe | set nonu | exe "te" | exe "startinsert"
command -nargs=0 FS FSHere

let NERDTreeIgnore = ['\.class$']

let personal_wiki = {}
let personal_wiki.path = '~/Documents/notes'
let personal_wiki.path_html = '~/Documents/notes/html'
let personal_wiki.syntax = 'default'
let personal_wiki.auto_export = 1

let high_seas_wiki = {}
let high_seas_wiki.path = '~/Documents/high_seas'
let high_seas_wiki.path_html = '~/Documents/high_seas/html'
let high_seas_wiki.syntax = 'default'
let high_seas_wiki.auto_export = 1

let g:vimwiki_list = [personal_wiki, high_seas_wiki]

function! NeatFoldText()
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('[+]' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

set foldtext=NeatFoldText()
set fillchars=fold:\ 
highlight Folded cterm=italic ctermbg=None ctermfg=Yellow

