" TODO
" orgmode config
" debugger config and keybinds
"	debug mode function
" lspsaga config and keybinds
" maximizer and windowswap keybinds
" fern keybindings? not really sure if it's worth it
" pretty status line
"	- git	- current function	- colors
" colorscheme: gotta keep background clear always
" folds are way too slow
" writing mode function
" general keybinds

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
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate'}
Plug 'Chiel92/vim-autoformat'
Plug 'mfussenegger/nvim-dap'		" Debugger
Plug 'rcarriga/nvim-dap-ui'			" Debugger UI
Plug 'glepnir/lspsaga.nvim'			" LSP UI
"Plug 'lambdalisue/fern.vim'		" Tree viewer

" Autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'windwp/nvim-autopairs'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lsp'			" Source
Plug 'hrsh7th/cmp-buffer'			" Source
Plug 'hrsh7th/cmp-path'				" Source
Plug 'saadparwaiz1/cmp_luasnip'		" Source
"Plug 'kdheepak/cmp-latex-symbols'	" Source
"Plug 'octaltree/cmp-look'			" Source

" Writing
Plug 'kristijanhusak/orgmode.nvim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"proselint (pip)

call plug#end()

" LSP Setup
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'texlab', 'pyright', 'rust_analyzer', 'clangd', 'bashls', 'html', 'jsonls', 'yamlls', 'vimls', 'zls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" Treesitter config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
	  -- these could be mapped better
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  ensure_installed = {
	  "bash",
	  "c",
	  "cmake",
	  "cpp",
	  "html",
	  "json",
	  "latex",
	  "lua",
	  "python",
	  "rust",
	  "toml",
	  "vim",
	  "yaml",
	  "zig",
  },
}
EOF

" Autocomplete Config
set completeopt=menu,menuone,noselect

lua <<EOF
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require'cmp'
  local luasnip = require("luasnip")

  require("luasnip/loaders/from_vscode").lazy_load({})
  require('nvim-autopairs').setup{}

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        -- vim.fn["vsnip#anonymous"](args.body)

        -- For `luasnip` user.
        require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
	  ["<CR>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			  cmp.confirm({ select = true })
		  else
			  fallback()
		  end
	  end, { "i", "s" }),

	  ["<Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_next_item()
		  elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		  elseif has_words_before() then
			cmp.complete()
		  else
			fallback()
		  end
	  end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

      { name = 'buffer' },
      { name = 'path' },
      { name = 'orgmode' },
    }
  })
EOF

" Debugger Config
lua <<EOF
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}
-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
EOF

" Autoformat Config
autocmd Filetype vim,tex let b:autoformat_autoindent=0 | let b:autoformat_remove_trailing_spaces=0
autocmd BufNewFile,BufRead *.tpp set filetype=cpp
autocmd! BufEnter *.hpp let b:fswitchdst = 'cpp,c,mpp'
autocmd! BufEnter *.tpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../include'

" Org Mode
lua << EOF
require('orgmode').setup({
  org_agenda_files = {'~/Documents/org/*'},
  org_default_notes_file = '~/Dropbox/org/notes.org',
})
EOF

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
highlight Folded cterm=italic guibg=None ctermbg=None ctermfg=Yellow

" Fold Methods
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Custom Commands
command! -nargs=0 WW
			\ Autoformat | w

command! -nargs=0 T
			\ set nonu | set signcolumn=no | exe "te" | exe "startinsert"
command! -nargs=0 TLeft
			\ vs | exe "T"
command! -nargs=0 TRight
			\ vs | exe "normal! <C-w>l" | exe "T"
command! -nargs=0 TUp
			\ sp | exe "T"
command! -nargs=0 TDown
			\ sp | exe "normal! <C-w>j" | exe "T"
command! -nargs=0 TTab
			\ tabe | exe "T"

command! -nargs=0 FS FSHere

command! -nargs=0 RRC
			\ mkview
			\ | silent! so $MYVIMRC
			\ | loadview

" Custom Key Bindings
" Additional escape sequences
tnoremap <c-[> <c-\><c-n>
tnoremap <c-w> <c-\><c-n><c-w>

" Buffer Navigation
nnoremap <silent> <M-j> <c-d> M
nnoremap <silent> <M-k> <c-u> M
inoremap <silent> <M-j> <Esc><c-d> Mi
inoremap <silent> <M-k> <Esc><c-u> Mi
nnoremap ( zk
nnoremap ) zj
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Space> za

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
nnoremap <silent> <leader>t :FloatermToggle<CR>
nnoremap <silent> <leader>T :T<CR>

" Move lines
nnoremap <silent> <c-j> :m .+1<CR>==
nnoremap <silent> <c-k> :m .-2<CR>==
inoremap <silent> <c-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <c-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <c-j> :m '>+1<CR>gv=gv
vnoremap <silent> <c-k> :m '<-2<CR>gv=gv

" Function Keys
nnoremap <silent> <F1> :VimwikiIndex<cr>
nnoremap <silent> <F4> :FloatermNew --autoinsert=true --height=0.95 --width=0.95 --wintype=float --autoclose=1 --title=lazygit lazygit<cr>

nnoremap <silent> <F5> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=building\ and\ running make run<cr>
nnoremap <silent> <F6> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=tests make test<cr>
nnoremap <silent> <F7> :FloatermNew --autoinsert=true --height=0.8 --width=81 --wintype=float --autoclose=0 --title=benchmarks make bench<cr>
nnoremap <silent> <F8> <CMD>lua require("dapui").toggle()<CR>

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
let g:gitgutter_set_sign_backgrounds = 0

let g:livepreview_previewer = 'qpdfview'
let g:vim_markdown_follow_anchor = 1
let g:python3_host_prog='/usr/bin/python'

