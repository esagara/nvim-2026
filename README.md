# neovim config

A minimal, stable Neovim configuration built around native Neovim 0.11 LSP,
with linting, formatting, autocomplete, and a small set of high-value plugins.

## Requirements

- Neovim >= 0.11
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) — required for Telescope live grep
- A [Nerd Font](https://www.nerdfonts.com/) — required for icons (JetBrains Mono Nerd Font recommended)
- Node.js — required for `typescript-language-server` and `eslint_d`
- Python >= 3.8 — required for `pyright` and `ruff`

On macOS all of these can be installed via Homebrew:

```bash
brew install neovim git ripgrep node python
brew install --cask font-jetbrains-mono-nerd-font
```

## Installation

### 1. Back up your existing config (if any)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### 2. Clone this repo

```bash
git clone <your-repo-url> ~/.config/nvim
```

### 3. Start Neovim

```bash
nvim
```

On first launch, lazy.nvim will bootstrap itself and install all plugins
automatically. Wait for the installation to complete — you can watch progress
in the `:Lazy` UI.

### 4. Install language servers and linters

Once plugins are installed, run the following inside Neovim:

```
:MasonInstall lua-language-server pyright typescript-language-server ruff eslint_d prettierd stylua
```

Or open `:Mason` and install them interactively with `i`.

### 5. Restart Neovim

Close and reopen Neovim. Language servers should now attach when you open
a supported file. Verify with:

```
:checkhealth lsp
```

---

## Structure

```
~/.config/nvim/
  init.lua        # editor options, keybinds, LSP config
  lua/
    plugins.lua   # all plugins managed by lazy.nvim
```

Everything lives in two files. `init.lua` handles core settings and LSP setup.
`plugins.lua` handles all plugin declarations and their configuration.

---

## Switching themes

The active theme is controlled by a single variable at the top of `lua/plugins.lua`:

```lua
local theme = "kanagawa"
```

To switch themes:

1. Change the `theme` variable to your desired theme name
2. Set the target theme plugin to `lazy = false` and `priority = 1000`
3. Set all other theme plugins to `lazy = true`
4. Restart Neovim

To preview a theme without changing your config, run:

```
:colorscheme <name>
```

This applies for the current session only.

Available themes:

| Plugin | Colorscheme names |
|---|---|
| `kanagawa` | `kanagawa`, `kanagawa-wave`, `kanagawa-dragon`, `kanagawa-lotus` |
| `tokyonight` | `tokyonight`, `tokyonight-night`, `tokyonight-storm`, `tokyonight-moon`, `tokyonight-day` |
| `catppuccin` | `catppuccin`, `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`, `catppuccin-mocha` |
| `rose-pine` | `rose-pine`, `rose-pine-moon`, `rose-pine-dawn` |
| `github-nvim-theme` | `github_dark`, `github_light`, `github_dark_dimmed`, `github_dark_high_contrast`, `github_light_high_contrast` |

Note: the plugin name and the colorscheme name are not always the same. Always use the
colorscheme name (right column) with `:colorscheme` and the `theme` variable in `plugins.lua`.

---

## Adding a new language server

1. Install the server via Mason:
   ```
   :MasonInstall <server-name>
   ```

2. Add a config entry in `init.lua` inside the `vim.schedule` block:
   ```lua
   vim.lsp.config("<server-name>", {
     cmd = { mason_bin .. "<server-binary>" },
   })
   ```

3. Add the server name to `vim.lsp.enable`:
   ```lua
   vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "<server-name>" })
   ```

4. Restart Neovim.

---

## Adding a new linter

1. Install the linter via Mason:
   ```
   :MasonInstall <linter-name>
   ```

2. Add an entry in the `nvim-lint` config block in `lua/plugins.lua`:
   ```lua
   lint.linters_by_ft = {
     <filetype> = { "<linter-name>" },
   }
   ```

3. Restart Neovim.

---

## Adding a new formatter

1. Install the formatter via Mason:
   ```
   :MasonInstall <formatter-name>
   ```

2. Add an entry in the `conform.nvim` config block in `lua/plugins.lua`:
   ```lua
   formatters_by_ft = {
     <filetype> = { "<formatter-name>" },
   }
   ```

3. Restart Neovim.

---

## Disabling format on save (temporarily)

Run this inside Neovim to disable for the current session:

```
:lua require("conform").setup({ format_on_save = false })
```

Formatting returns to normal on next restart.

---

## Updating plugins

```
:Lazy update
```

To roll back to the previous state if something breaks:

```
:Lazy restore
```

The `lazy-lock.json` lockfile pins all plugin versions. Commit this file
to version control so you can always reproduce a known-good state.

---

## Installed plugins

| Plugin | Purpose |
|---|---|
| lazy.nvim | Plugin manager |
| mason.nvim | Installs language servers, linters, formatters |
| mason-lspconfig.nvim | Bridges Mason with Neovim's native LSP |
| nvim-lspconfig | Provides default LSP server configurations |
| nvim-lint | Asynchronous linting on save |
| conform.nvim | Formatting on save |
| nvim-cmp | Autocomplete engine |
| LuaSnip | Snippet engine |
| friendly-snippets | Preconfigured snippet library |
| nvim-autopairs | Auto-closes brackets, braces, quotes |
| telescope.nvim | Fuzzy finder for files, grep, buffers |
| nvim-treesitter | Better syntax highlighting and indentation |
| gitsigns.nvim | Git diff in gutter, hunk staging and blame |
| trouble.nvim | Diagnostic panel for errors and warnings |
| which-key.nvim | Keybinding hint popup |
| lualine.nvim | Statusline |
| nvim-web-devicons | File type icons |
| vim-sleuth | Auto-detects indentation from file content |
| kanagawa.nvim | Theme (variants: kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus) |
| tokyonight.nvim | Theme (variants: tokyonight, tokyonight-night, tokyonight-storm, tokyonight-moon, tokyonight-day) |
| catppuccin | Theme (variants: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha) |
| rose-pine | Theme (variants: rose-pine, rose-pine-moon, rose-pine-dawn) |
| github-nvim-theme | Theme (variants: github_dark, github_light, github_dark_dimmed, github_dark_high_contrast, github_light_high_contrast) |

---

## Language support

| Language | Server | Linter | Formatter |
|---|---|---|---|
| TypeScript / TSX | ts_ls | eslint_d | prettierd |
| JavaScript / JSX | ts_ls | eslint_d | prettierd |
| Python | pyright | ruff | ruff_format |
| Lua | lua_ls | — | stylua |

---

## Key bindings

### Telescope
| Key | Action |
|---|---|
| `<Space> ff` | Find files |
| `<Space> fg` | Live grep |
| `<Space> fb` | Browse buffers |
| `<Space> fh` | Search help tags |

### Diagnostics
| Key | Action |
|---|---|
| `<Space> e` | Show diagnostic float |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<Space> xx` | Toggle trouble panel |
| `<Space> xb` | Buffer diagnostics |

### Git (gitsigns)
| Key | Action |
|---|---|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<Space> hs` | Stage hunk |
| `<Space> hr` | Reset hunk |
| `<Space> hp` | Preview hunk |
| `<Space> hb` | Blame line |

### Navigation
| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between splits |
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `<Esc>` | Clear search highlights |

### Autocomplete
| Key | Action |
|---|---|
| `<C-Space>` | Trigger completion |
| `<Tab>` | Next item / expand snippet |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm selection |
| `<C-e>` | Close completion |
