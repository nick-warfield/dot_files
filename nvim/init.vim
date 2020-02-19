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

tnoremap <Esc> <C-\><C-n>

" Plugins go here

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'airblade/vim-gitgutter'             " show git changes in file
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'                " tree view of files
"Plug 'scrooloose/syntastic'               " check code syntax
Plug 'octol/vim-cpp-enhanced-highlight'   " additional c++ highlighting
Plug 'majutsushi/tagbar'                  " make ctags
Plug 'valloric/youcompleteme'             " auto complete
Plug 'kana/vim-altr'
Plug 'derekwyatt/vim-fswitch'
Plug 'neovim/pynvim'
Plug 'w0rp/ale'							" linter
Plug 'keith/swift.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'plasticboy/vim-markdown'
Plug 'jceb/vim-orgmode'
Plug 'itchyny/calendar.vim'

" Plugins stop here
call plug#end()

let g:ale_linters = { 'cpp': ['ccls', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc'], }
let g:ale_cpp_gcc_options = '-std=c++17 -Wall'
let g:ale_set_highlights = 0

let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

let g:rust_recommended_style = 0
let g:rust_fold = 1

let g:livepreview_previewer = 'zathura'

command -nargs=1 E tabe src/<args>.cpp | NERDTree | exe "normal jo" | exe "normal! <C-w>l" | vs | e include/<args>.hpp
command -nargs=0 P e makefile | NERDTree | exe "normal jo" | exe "normal! <C-w>l" | vs | split | exe "normal! 10<C-w>+" | e src/main.cpp | exe "normal! <C-w>l" | set nonu | exe "te" | normal! <C-\><C-N><C-w>h
command -nargs=0 FS FSHere

let NERDTreeIgnore = ['\.class$']
