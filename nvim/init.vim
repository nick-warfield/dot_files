" TODO:
"	- load large files faster
"	- Fold by ctags?
"
"	- customize status bar
"	- customize tab bar
"	- clock
"
"	- automatically auto format code
"	- better cpp syntax highlighting (highlight stuff from libs)
"	- function declaration preview
"
"	- custom home page
"	- better markdown highlighting and formating
"	- plaintext file sync
"	- email?
"	- calendar?

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

noremap <a-[> <c-[>
tnoremap <a-[> <c-\><c-n>
tnoremap <c-w> <c-\><c-n><c-w>
nnoremap ( zk
nnoremap ) zj
nnoremap <silent> <Space> za

nnoremap <M-j> <c-d> M
nnoremap <M-k> <c-u> M
nnoremap <M-t> <c-]>
inoremap <M-j> <Esc><c-d> M
inoremap <M-k> <Esc><c-u> M
inoremap <M-t> <Esc><c-]>

nnoremap <S-M-J> :wincmd j<CR>
nnoremap <S-M-K> :wincmd k<CR>
nnoremap <S-M-L> :wincmd l<CR>
nnoremap <S-M-H> :wincmd h<CR>
inoremap <S-M-J> <Esc>:w <bar> wincmd j<CR>
inoremap <S-M-K> <Esc>:w <bar> wincmd k<CR>
inoremap <S-M-L> <Esc>:w <bar> wincmd l<CR>
inoremap <S-M-H> <Esc>:w <bar> wincmd h<CR>

nnoremap <silent> <c-j> :m .+1<CR>==
nnoremap <silent> <c-k> :m .-2<CR>==
inoremap <silent> <c-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <c-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <c-j> :m '>+1<CR>gv=gv
vnoremap <silent> <c-k> :m '<-2<CR>gv=gv

" Plugins go here
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'gioele/vim-autoswap'
Plug 'ludovicchabant/vim-gutentags'

" Fast File and Tag Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

Plug 'neovim/pynvim'

Plug 'w0rp/ale'							  " linter
Plug 'octol/vim-cpp-enhanced-highlight'   " additional c++ highlighting
Plug 'derekwyatt/vim-fswitch'

" Autocompletion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'

" Groupware
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

let g:ale_linters = { 'cpp': ['clang++'], 'c': ['clang'], }
let g:ale_c_cc_executable = 'clang'
let g:ale_cpp_cc_executable = 'clang++'
let g:ale_c_cc_options = '-std=c++17 -Wall -Iinclude -isystem lib'
let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wno-missing-braces -Iinclude -isystem lib'

let g:fzf_buffers_jump = 1
let g:fzf_preview_window = 'right:70%'
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.7, 'yoffset': 0.2, 'border': 'right' } }

function! s:find_files()
	let l:bat_options = '--preview=bat --style=plain --color=always {}'
	let l:fzf_options = [
	\		'--border',
	\		'--margin=0',
	\		'--inline-info',
	\		'--reverse',
	\		'--tabstop=4',
	\		'--black',
	\		l:bat_options,
	\		'--preview-window=right:70%' ]
	call fzf#run(fzf#wrap({ 'source': 'ag --ignore lib -g ./', 'options': fzf_options } ))
endfunction
command! -bang -nargs=0 -complete=dir Files call s:find_files()

command! -bang -nargs=* -complete=dir BTags
	\ call fzf#vim#buffer_tags(
	\	<q-args>,
	\	{ 'options': [
	\		'--border',
	\		'--margin=0',
	\		'--inline-info',
	\		'--reverse',
	\		'--tabstop=2',
	\		'--black' ] },
	\	<bang>0)

command! -bang -nargs=* -complete=dir Lines
	\ call fzf#vim#lines(
	\	<q-args>,
	\	{ 'options': [
	\		'--reverse',
	\		'--tabstop=2',
	\		'--black' ] },
	\	<bang>0)

nnoremap <c-f> :Files<CR>
nnoremap <c-t> :BTags<CR>
nnoremap // :Lines<CR>

let g:rust_recommended_style = 0
let g:rust_fold = 1

let g:livepreview_previewer = 'qpdfview'

set signcolumn=yes
let g:gitgutter_set_sign_backgrounds = 1
highlight clear SignColumn

" this is also linting, which is giving me bad warnings/errors
"call neomake#configure#automake('nw', 1000)

nnoremap  <F5> :!make run<CR>
nnoremap  <F6> :!make test<CR>
nnoremap  <F7> :NERDTreeToggle<CR>
nnoremap  <F8> :TagbarToggle<CR>
nnoremap  <F9> zR
nnoremap <F10> zM
nnoremap <F11> :set nu!<CR>

let g:tagbar_autofocus = 1
let g:tagbar_wrap = 1

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

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

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

