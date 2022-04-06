-- Plugins
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
	-- General Goodies
	use "ellisonleao/gruvbox.nvim"
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'gioele/vim-autoswap'
	use 'farmergreg/vim-lastplace'
	use 'derekwyatt/vim-fswitch'
	use 'airblade/vim-gitgutter'
	use 'APZelos/blamer.nvim'

	-- Window/Buffer Management
	use 'voldikss/vim-floaterm'
	use 'szw/vim-maximizer'
	--use 'vim-windowswap'

	-- Dev Tools
	use 'neovim/nvim-lspconfig'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'Chiel92/vim-autoformat'
	use 'mfussenegger/nvim-dap'      -- Debugger
	use 'rcarriga/nvim-dap-ui'       -- Debugger UI
	use 'tami5/lspsaga.nvim'       -- LSP UI
	--use 'lambdalisue/fern.vim'       -- Tree viewer
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	-- Autocomplete
	use 'hrsh7th/nvim-cmp'
	use 'windwp/nvim-autopairs'
	use 'L3MON4D3/LuaSnip'
	use 'rafamadriz/friendly-snippets'
	use 'hrsh7th/cmp-nvim-lsp'       -- Source
	use 'hrsh7th/cmp-buffer'         -- Source
	use 'hrsh7th/cmp-path'           -- Source
	use 'hrsh7th/cmp-cmdline'        -- Source
	use 'saadparwaiz1/cmp_luasnip'   -- Source
	--use 'kdheepak/cmp-latex-symbols' -- Source
	--use 'octaltree/cmp-look'         -- Source

	-- Writing
	use 'nvim-orgmode/orgmode'
	use 'vimwiki/vimwiki'
	use { 'junegunn/goyo.vim', cmd = 'Goyo' }
	use { 'xuhdev/vim-latex-live-preview', ft = 'tex' }
	--proselint (pip)

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)

-- LSP Setup
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
local servers = {
	'sorbet',
	'texlab',
	'pyright',
	'rust_analyzer',
	'clangd',
	'bashls',
	'html',
	'jsonls',
	'yamlls',
	'vimls',
	'zls'
}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		}
	}
end

-- Treesitter config
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

-- Autocomplete Config
vim.o.completeopt = 'menu,menuone,noselect'

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
			require('luasnip').lsp_expand(args.body)
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

		["<Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end,
			s = i,
		}),

		["<S-Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end,
			s = i
		}),
	},
	experimental = {
		ghost_text = true,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'orgmode' },
		{ name = 'path' },
		{ name = 'buffer' },
	}
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	view = {
		entries = { name = 'wildmenu' }
	},
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	view = {
		entries = { name = 'wildmenu' }
	},
	sources = cmp.config.sources({
		{ name = 'cmdline' },
		{ name = 'path' },
	})
})

-- Lspsaga default config
local saga = require 'lspsaga'
saga.init_lsp_saga()

-- Add autocomplete to LSP config
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		capabilities = capabilities
	}
end

-- Telescope Config
require('telescope').setup {
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
}

require('telescope').load_extension('fzf')

-- Debugger Config
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

-- Orgmode Config
-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
	-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
	highlight = {
		enable = true,
		--disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
		additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
	},
	ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
	org_agenda_files = { '~/Documents/org/*' },
	org_default_notes_file = '~/Documents/org/refile.org',
})

vim.opt.compatible = false
vim.g.vimwiki_list = { {
	['path'] = '~/Documents/wiki/',
	['path_html'] = '~/Documents/wiki/html/'
    }
}

-- Remaining Vimscript to convert
--	* autocmd and cmd still require vimscript
--
-- Autoformat Config
vim.cmd [[
autocmd Filetype vim,tex let b:autoformat_autoindent=0 | let b:autoformat_remove_trailing_spaces=0
autocmd BufNewFile,BufRead *.tpp set filetype=cpp
autocmd! BufEnter *.hpp let b:fswitchdst = 'cpp,c,mpp'
autocmd! BufEnter *.tpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../include'

" Folds Config
augroup remember_folds
autocmd!
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent! loadview
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
set foldminlines=10

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
noremap  <silent> <S-M-J> <Cmd>wincmd j<CR>
noremap  <silent> <S-M-K> <Cmd>wincmd k<CR>
noremap  <silent> <S-M-L> <Cmd>wincmd l<CR>
noremap  <silent> <S-M-H> <Cmd>wincmd h<CR>

inoremap <silent> <S-M-J> <Cmd>wincmd j<CR><Esc>
inoremap <silent> <S-M-K> <Cmd>wincmd k<CR><Esc>
inoremap <silent> <S-M-L> <Cmd>wincmd l<CR><Esc>
inoremap <silent> <S-M-H> <Cmd>wincmd h<CR><Esc>

tnoremap <silent> <S-M-J> <Cmd>wincmd j<CR>
tnoremap <silent> <S-M-K> <Cmd>wincmd k<CR>
tnoremap <silent> <S-M-L> <Cmd>wincmd l<CR>
tnoremap <silent> <S-M-H> <Cmd>wincmd h<CR>

noremap  <silent> <S-M-M> <Cmd>MaximizerToggle<CR>
inoremap <silent> <S-M-M> <Cmd>MaximizerToggle<CR>
tnoremap <silent> <S-M-M> <C-\><C-n><Cmd>MaximizerToggle<CR>i

" Terminal Creation
noremap  <silent> <leader>t <Cmd>FloatermToggle default<CR>
inoremap <silent> <leader>t <Cmd>FloatermToggle default<CR>
tnoremap <silent> <leader>t <Cmd>FloatermToggle default<CR>

" Telescope keybinds
noremap  <silent> <leader>ff <Cmd>Telescope find_files theme=ivy<CR>
inoremap <silent> <leader>ff <Cmd>Telescope find_files theme=ivy<CR>
tnoremap <silent> <leader>ff <Cmd>Telescope find_files theme=ivy<CR>

" live_grep requires having ripgrep installed
noremap  <silent> <leader>fg <Cmd>Telescope live_grep theme=ivy<CR>
inoremap <silent> <leader>fg <Cmd>Telescope live_grep theme=ivy<CR>
tnoremap <silent> <leader>fg <Cmd>Telescope live_grep theme=ivy<CR>

noremap  <silent> <leader>fz <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>
inoremap <silent> <leader>fz <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>
tnoremap <silent> <leader>fz <Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>

noremap  <silent> <leader>fb <Cmd>Telescope buffers theme=dropdown previewer=false<CR>
inoremap <silent> <leader>fb <Cmd>Telescope buffers theme=dropdown previewer=false<CR>
tnoremap <silent> <leader>fb <Cmd>Telescope buffers theme=dropdown previewer=false<CR>

noremap  <silent> <leader>fh <Cmd>Telescope help_tags theme=dropdown previewer=false<CR>
inoremap <silent> <leader>fh <Cmd>Telescope help_tags theme=dropdown previewer=false<CR>
tnoremap <silent> <leader>fh <Cmd>Telescope help_tags theme=dropdown previewer=false<CR>

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
set linebreak

if has('nvim')
	let $GIT_EDITOR = 'nvr -cc split --remote-wait'
	endif
	autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

	colorscheme gruvbox
	set termguicolors
	set bg=dark

	hi Normal guibg=NONE ctermbg=NONE
	hi SignColumn guibg=NONE ctermbg=NONE
	hi VertSplit guibg=NONE ctermbg=NONE

	hi GitGutterAdd guibg=NONE  ctermbg=NONE
	hi GitGutterDelete guibg=NONE  ctermbg=NONE
	hi GitGutterChange guibg=NONE  ctermbg=NONE

	hi GruvboxAquaSign guibg=NONE ctermbg=NONE
	hi GruvboxBlueSign guibg=NONE ctermbg=NONE
	hi GruvboxGreenSign guibg=NONE ctermbg=NONE
	hi GruvboxOrangeSign guibg=NONE ctermbg=NONE
	hi GruvboxPurpleSign guibg=NONE ctermbg=NONE
	hi GruvboxRedSign guibg=NONE ctermbg=NONE
	hi GruvboxYellowSign guibg=NONE ctermbg=NONE

	autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
	autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
	autocmd vimenter * hi FloatermBorder guibg=NONE ctermbg=NONE
	autocmd vimenter * FloatermNew --silent --name=default --width=0.7 --height=0.9

	set signcolumn=yes
	set updatetime=750
	let g:gitgutter_set_sign_backgrounds = 0

	let g:livepreview_previewer = 'qpdfview'
	let g:vim_markdown_follow_anchor = 1
	let g:python3_host_prog='/usr/bin/python'

	]]
