-- =============================================================================
-- LEADER KEY
-- Must be set before lazy.nvim loads so all plugins pick it up correctly
-- =============================================================================
vim.g.mapleader = " "

-- =============================================================================
-- EDITOR OPTIONS
-- Core editor behaviour and appearance settings
-- =============================================================================

-- Indentation (global defaults, 2 spaces)
vim.opt.expandtab = true -- tabs become spaces
vim.opt.shiftwidth = 2 -- indent size
vim.opt.tabstop = 2 -- tab display size
vim.opt.softtabstop = 2 -- tab key inserts this many spaces

-- Python override (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- use system clipboard for all operations

-- Line numbers
vim.opt.number = true -- show absolute line number on current line
vim.opt.relativenumber = true -- show relative numbers on all other lines

-- Searching
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- unless you type a capital letter
vim.opt.hlsearch = false -- don't highlight all search results
vim.opt.incsearch = true -- show matches as you type

-- Scrolling
vim.opt.scrolloff = 8 -- keep 8 lines above/below cursor when scrolling
vim.opt.sidescrolloff = 8 -- keep 8 columns left/right when scrolling horizontally

-- Splits
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.splitright = true -- vertical splits open to the right

-- Files
vim.opt.swapfile = false -- don't create swap files
vim.opt.backup = false -- don't create backup files
vim.opt.undofile = true -- persist undo history between sessions

-- Appearance
vim.opt.termguicolors = true -- enables full colour support in terminal
vim.opt.signcolumn = "yes" -- always show the gutter so it doesn't shift text
vim.opt.wrap = false -- don't wrap long lines
vim.opt.cursorline = true -- highlight the current line

-- =============================================================================
-- DIAGNOSTICS
-- Controls how LSP and linter errors/warnings are displayed
-- =============================================================================

-- How long the cursor must rest before CursorHold fires (milliseconds)
vim.opt.updatetime = 500

-- Automatically show diagnostic float when cursor rests on a line with an error
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

-- Diagnostic display configuration
vim.diagnostic.config({
	virtual_text = true, -- show inline error text at end of line
	signs = true, -- show gutter signs
	underline = true, -- underline offending code
	update_in_insert = false, -- don't show errors while typing
	float = {
		border = "rounded",
		source = true, -- show which linter/LSP triggered the diagnostic
	},
})

-- =============================================================================
-- KEYBINDS
-- =============================================================================

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostic navigation
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- =============================================================================
-- PLUGIN MANAGER (lazy.nvim)
-- Bootstraps lazy.nvim if not installed, then loads plugins from lua/plugins.lua
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- =============================================================================
-- LSP
-- Configures language servers using Neovim's native LSP client (0.11+).
-- Wrapped in vim.schedule to ensure Mason binaries are available on PATH
-- before the servers are enabled.
-- To add a new server: install via :MasonInstall, add vim.lsp.config and
-- include in vim.lsp.enable below.
-- =============================================================================
vim.schedule(function()
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

	vim.lsp.config("lua_ls", {
		cmd = { mason_bin .. "lua-language-server" },
	})

	vim.lsp.config("pyright", {
		cmd = { mason_bin .. "pyright-langserver", "--stdio" },
	})

	vim.lsp.config("ts_ls", {
		cmd = { mason_bin .. "typescript-language-server", "--stdio" },
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	})

	vim.lsp.enable({ "lua_ls", "pyright", "ts_ls" })
end)
