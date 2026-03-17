local theme = "kanagawa"

return {
	-- =========================================================================
	-- THEMES
	-- Only the active theme should have lazy = false and priority = 1000.
	-- To switch themes: update the `theme` variable above, set the target
	-- plugin to lazy = false + priority = 1000, and set all others to lazy = true
	-- =========================================================================
	{ "folke/tokyonight.nvim", lazy = true },
	{ "catppuccin/nvim", lazy = true },
	{ "rose-pine/neovim", lazy = true },
	{ "projekt0n/github-nvim-theme", lazy = true },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme(theme)
		end,
	},

	-- =========================================================================
	-- LSP
	-- Language server support. Mason handles installation of language servers,
	-- mason-lspconfig bridges Mason with Neovim's native LSP client, and
	-- nvim-lspconfig provides default server configurations.
	-- Servers are enabled in init.lua via vim.lsp.enable()
	-- =========================================================================
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ts_ls" },
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},

	-- =========================================================================
	-- LINTING
	-- nvim-lint runs linters asynchronously on save and buffer read.
	-- Linters are installed via :MasonInstall (e.g. ruff, eslint_d)
	-- =========================================================================
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				javascriptreact = { "eslint_d" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- =========================================================================
	-- FORMATTING
	-- conform.nvim formats on save. prettierd is used for JS/TS and requires
	-- a prettier config file in the project root (require_cwd = true).
	-- ruff_format handles Python, stylua handles Lua.
	-- =========================================================================
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_format" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					javascriptreact = { "prettierd" },
					lua = { "stylua" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters = {
					prettierd = {
						cwd = require("conform.util").root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							"prettier.config.js",
							"package.json",
						}),
						require_cwd = true,
					},
				},
			})
		end,
	},

	-- =========================================================================
	-- COMPLETION
	-- nvim-cmp provides autocomplete. Sources are loaded in priority order:
	-- LSP → snippets → buffer words → file paths.
	-- LuaSnip handles snippet expansion, with friendly-snippets providing
	-- a library of preconfigured snippets for many languages.
	-- =========================================================================
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
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
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- =========================================================================
	-- EDITOR ENHANCEMENTS
	-- nvim-autopairs: auto-closes brackets, braces, quotes etc.
	-- vim-sleuth: automatically detects and sets indentation from file content
	-- =========================================================================
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{ "tpope/vim-sleuth" },

	-- =========================================================================
	-- NAVIGATION
	-- Telescope: fuzzy finder for files, live grep, buffers, and help tags.
	-- Requires ripgrep for live_grep (brew install ripgrep)
	-- =========================================================================
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
		end,
	},

	-- =========================================================================
	-- SYNTAX
	-- Treesitter provides better syntax highlighting and smarter indentation.
	-- auto_install = true will install parsers for new filetypes automatically.
	-- =========================================================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					"lua",
					"python",
					"typescript",
					"tsx",
					"javascript",
					"json",
					"markdown",
				},
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},

	-- =========================================================================
	-- GIT
	-- gitsigns shows add/change/delete indicators in the gutter and provides
	-- hunk-level staging, resetting, previewing, and inline blame.
	-- =========================================================================
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
					vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
					vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
					vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
					vim.keymap.set("n", "<leader>hb", gs.blame_line, { buffer = bufnr, desc = "Blame line" })
				end,
			})
		end,
	},

	-- =========================================================================
	-- UI
	-- nvim-web-devicons: file type icons (required by trouble and lualine)
	-- trouble.nvim: diagnostic panel showing errors and warnings project-wide
	-- which-key: shows available keybindings when pausing after a prefix key
	-- lualine: statusline showing mode, branch, diagnostics, filetype, position
	-- =========================================================================
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-web-devicons" },
		config = function()
			require("trouble").setup()
			vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle trouble" })
			vim.keymap.set(
				"n",
				"<leader>xb",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				{ desc = "Buffer diagnostics" }
			)
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = theme,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
