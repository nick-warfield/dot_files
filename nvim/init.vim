" TODO:
"	- load large files faster
"	- Fold by ctags?
"	- vim-file fold pluging
"
"	- customize status bar
"	- customize tab bar
"	- clock
"
"	- clear background hilights in plugins
"	- use custom signs in ALE, gitgutter, etc
"
"	- custom home page
"	- better markdown highlighting and formating
"	- plaintext file sync
"	- email?
"	- calendar?

" Plugins
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.config/nvim/plugged')

"General Goodies
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'gioele/vim-autoswap'
Plug 'farmergreg/vim-lastplace'
Plug 'voldikss/vim-floaterm'
"Plug 'szw/vim-maximizer'
"Plug 'vim-windowswap'
Plug 'derekwyatt/vim-fswitch'
Plug 'airblade/vim-gitgutter'
"Plug 'rbong/vim-crystalline'		" airline replacement

" Dev Tools
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'mfussenegger/nvim-dap'
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}		" Autocomplete
"Plug 'lambdalisue/fern.vim'					" Tree viewer
"Plug 'glepnir/lspsaga.nvim'					" LSP UI
"Plug 'rcarriga/nvim-dap-ui'					" Debugger UI
Plug 'Chiel92/vim-autoformat'

" Writing
Plug 'vimwiki/vimwiki'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"proselint (pip)

call plug#end()

let g:python3_host_prog='/usr/bin/python'
let gutentags_cache_dir='~/.cache/nvim/gutentags'

" ncm2 config
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" ale config
let g:ale_linters = { 'cpp': ['clang++'], 'c': ['clang'], }
let g:ale_c_cc_executable = 'clang'
let g:ale_cpp_cc_executable = 'clang++'
let g:ale_c_cc_options = '-std=c++17 -Wall -Iinclude -isystem lib'
let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wno-missing-braces -Iinclude -isystem lib'

" fzf config
let g:fzf_buffers_jump = 1
let g:fzf_preview_window = 'right:70%'
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.7, 'yoffset': 0.2, 'border': 'right' } }

function! s:find_home_files()
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
	call fzf#run(fzf#wrap({ 'source': 'ag -g '''' ~', 'options': fzf_options } ))
endfunction

function! s:find_local_files()
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
	call fzf#run(fzf#wrap({ 'source': 'ag --ignore lib -g '''' ./', 'options': fzf_options } ))
endfunction

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


" Autoformat Config
autocmd Filetype vim,tex let b:autoformat_autoindent=0 | let b:autoformat_remove_trailing_spaces=0
autocmd BufNewFile,BufRead *.tpp set filetype=cpp
autocmd! BufEnter *.hpp let b:fswitchdst = 'cpp,c,tpp'
autocmd! BufEnter *.tpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../include'

" Auto build and test
autocmd BufWrite *.rs :AsyncRun cargo build
autocmd BufWrite *.rs :AsyncRun cargo test
autocmd BufWrite *.*pp :AsyncRun make
autocmd BufWrite *.*pp :AsyncRun make test

" Tagbar + Nerdtree Config
let g:tagbar_autofocus = 1
"let g:tagbar_wrap = 1
let NERDTreeIgnore = ['\.class$']

" Vimwiki Config
let personal_wiki = {}
let personal_wiki.path = '~/Documents/notes'
let personal_wiki.path_html = '~/Documents/notes/html'
let personal_wiki.syntax = 'markdown'
let personal_wiki.ext = 'md'
let personal_wiki.auto_export = 1

let high_seas_wiki = {}
let high_seas_wiki.path = '~/Documents/high_seas'
let high_seas_wiki.path_html = '~/Documents/high_seas/html'
"let high_seas_wiki.syntax = 'default'
let high_seas_wiki.auto_export = 1

let g:vimwiki_list = [personal_wiki, high_seas_wiki]

" disable tab mappings so autocomplete works
let g:vimwiki_key_mappings = {
            \ 'all_maps': 1,
            \ 'global': 1,
            \ 'headers': 1,
            \ 'text_objs': 1,
            \ 'table_format': 1,
            \ 'table_mappings': 0,
            \ 'lists': 1,
            \ 'links': 1,
            \ 'html': 1,
            \ 'mouse': 0,
            \ }

" Folds Config
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.vim mkview
  autocmd BufWinEnter *.vim silent! loadview
augroup END

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

" Fold Text
set foldtext=NeatFoldText()
set fillchars=fold:\ "Comment for single space
highlight Folded cterm=italic ctermbg=None ctermfg=Yellow

" Fold Methods
set foldmethod=syntax
autocmd Filetype vim setlocal foldmethod=manual

" Custom Commands
command! -nargs=0 WW
			\ Autoformat | w
command! -bang -nargs=0 -complete=dir FindLocalFiles
			\ call s:find_local_files()
command! -bang -nargs=0 -complete=dir FindHomeFiles
			\ call s:find_home_files()

command! -nargs=0 T
			\ set nonu | exe "te" | exe "startinsert"
command! -nargs=0 TLeft
			\ vs | set nonu | exe "te" | exe "startinsert"
command! -nargs=0 TRight
			\ vs | exe "normal! <C-w>l" | set nonu | exe "te" | exe "startinsert"
command! -nargs=0 TUp
			\ split | set nonu | exe "te" | exe "startinsert"
command! -nargs=0 TDown
			\ split | exe "normal! <C-w>j" | set nonu | exe "te" | exe "startinsert"
command! -nargs=0 TTab
			\ tabe | set nonu | exe "te" | exe "startinsert"

command! -nargs=0 FS FSHere

command! -nargs=0 RRC
			\ mkview
			\ | silent! so $MYVIMRC
			\ | loadview

" Custom Key Bindings
" Additional escape sequences
inoremap <a-[> <c-[>
vnoremap <a-[> <c-[>
tnoremap <a-[> <c-\><c-n>
tnoremap <c-[> <c-\><c-n>
tnoremap <c-w> <c-\><c-n><c-w>

" Buffer Navigation
nnoremap <silent> <M-j> <c-d> M
nnoremap <silent> <M-k> <c-u> M
inoremap <silent> <M-j> <Esc><c-d> M
inoremap <silent> <M-k> <Esc><c-u> M
nnoremap ( zk
nnoremap ) zj

" Window Select
nnoremap <silent> <S-M-J> :wincmd j<CR>
nnoremap <silent> <S-M-K> :wincmd k<CR>
nnoremap <silent> <S-M-L> :wincmd l<CR>
nnoremap <silent> <S-M-H> :wincmd h<CR>
inoremap <silent> <S-M-J> <Esc>:w <bar> wincmd j<CR>
inoremap <silent> <S-M-K> <Esc>:w <bar> wincmd k<CR>
inoremap <silent> <S-M-L> <Esc>:w <bar> wincmd l<CR>
inoremap <silent> <S-M-H> <Esc>:w <bar> wincmd h<CR>

" Terminal Creation
nnoremap <silent> t :FloatermToggle<CR>
nnoremap <silent> T :T<CR>

" Move lines
nnoremap <silent> <c-j> :m .+1<CR>==
nnoremap <silent> <c-k> :m .-2<CR>==
inoremap <silent> <c-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <c-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <c-j> :m '>+1<CR>gv=gv
vnoremap <silent> <c-k> :m '<-2<CR>gv=gv

" Searching
nnoremap <c-o> :FindLocalFiles<CR>
"nnoremap <c-s-o> :FindHomeFiles<Cr>	" these keybindings are conflicting
nnoremap <c-f> :BTags<CR>
nnoremap <c-t> <c-]>
inoremap <c-t> <Esc><c-]>
nnoremap // :Lines<CR>

" Function Keys
nnoremap <silent> <F1> :VimwikiIndex<cr>
"F1-F3 reserved for groupware
nnoremap <silent> <F4> :FloatermNew --autoinsert=true --height=0.95 --width=0.95 --wintype=float --autoclose=1 --title=lazygit lazygit<cr>

nnoremap <silent> <F5> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=building\ and\ running make run<cr>
nnoremap <silent> <F6> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=tests make test<cr>
nnoremap <silent> <F7> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=benchmarks make bench<cr>

nnoremap <silent> <F11> :NERDTreeToggle<CR>
nnoremap <silent> <F12> :TagbarToggle<CR>

" Misc
nnoremap <silent> <Space> za
nnoremap <silent> j gj
nnoremap <silent> k gk

" Global Settings
set termguicolors
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
set undofile
set undodir=~/.cache/nvim/undo_history/

colorscheme gruvbox
let g:gruvbox_transparent_bg = 1
let g:gruvbox_italic = 1

autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
autocmd vimenter * hi FloatermBorder guibg=NONE ctermbg=NONE

set signcolumn=yes
set updatetime=750
highlight clear SignColumn
let g:gitgutter_set_sign_backgrounds = 1

let g:rust_recommended_style = 0
let g:rust_fold = 1

let g:livepreview_previewer = 'qpdfview'

let g:vim_markdown_follow_anchor = 1

let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

