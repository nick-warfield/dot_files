set showmatch
set ignorecase
set hlsearch
set tabstop=4
set softtabstop=4
set noexpandtab
set shiftwidth=4
set autoindent
set number
set wildmode=longest,list
set autoread
set mouse=a

" for vimwiki plugin
set nocompatible
filetype plugin on
syntax on

noremap <A-[> <C-[>
tnoremap <A-[> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

" Plugins go here

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'airblade/vim-gitgutter'             " show git changes in file
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'                " tree view of files
Plug 'majutsushi/tagbar'                  " make ctags

Plug 'neovim/pynvim'
"Plug 'valloric/youcompleteme'             " auto complete

Plug 'w0rp/ale'							  " linter
Plug 'octol/vim-cpp-enhanced-highlight'   " additional c++ highlighting
"Plug 'kana/vim-altr'
Plug 'derekwyatt/vim-fswitch'

Plug 'benekastah/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoinclude.vim'
Plug 'deoplete-plugins/deoplete-jedi'	" Python autocomplete
Plug 'sebastianmarkow/deoplete-rust'	" Rust autocomplete

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

call deoplete#enable()
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
call deoplete#custom#var('clangx', 'default_c_options', ['-I/usr/include/vulkan', '-I/usr/include/GLFW', '-I/usr/include/glm', '-I/usr/include/GL'])
call deoplete#custom#var('clangx', 'default_cpp_options', ['-I/usr/include/vulkan', '-I/usr/include/GLFW', '-I/usr/include/glm', '-I/usr/include/GL'])
let g:deoplete#sources#rust#racer_binary='~/.cargo/bin/racer'

let g:ale_linters = { 'cpp': ['ccls', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc'], }
let g:ale_cpp_gcc_options = '-std=c++17 -Wall'
let g:ale_set_highlights = 0

let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

let g:rust_recommended_style = 0
let g:rust_fold = 1

let g:livepreview_previewer = 'qpdfview'

call neomake#configure#automake('nw', 500)
nmap <F5> :!make run<CR>
nmap <F6> :!make test<CR>
nmap <F7> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

command -nargs=0 T set nonu | exe "te"
command -nargs=0 TLeft vs | set nonu | exe "te"
command -nargs=0 TRight vs | exe "normal! <C-w>l" | set nonu | exe "te"
command -nargs=0 TUp split | set nonu | exe "te"
command -nargs=0 TDown split | exe "normal! <C-w>j" | set nonu | exe "te"
command -nargs=0 TTab tabe | set nonu | exe "te"
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
