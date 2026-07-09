-- main key for custom macros
vim.g.mapleader = " "

-- show number main string
vim.opt.number = true

-- show numbers relative main string for other strings
vim.opt.relativenumber = true

-- some light for main string
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- clipboard on system buffer
vim.opt.clipboard = "unnamedplus"

-- Treat Russian layout keys as their English equivalents in Normal/Visual modes.
local ru = [[ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]

local langmap = {}
for i = 1, vim.fn.strchars(ru) do
	local r = vim.fn.strcharpart(ru, i - 1, 1)
	local e = vim.fn.strcharpart(en, i - 1, 1)
	table.insert(langmap, r .. vim.fn.escape(e, [[\,;]]))
end

vim.o.langmap = table.concat(langmap, ",")	

-- Russian aliases for common Ex commands, so :ц works like :w.
local cmd_aliases = {
	["ц"] = "w",
	["цй"] = "wq",
	["й"] = "q",
	["йа"] = "qa",
	["у"] = "e",
	["бн"] = "bn",
	["бп"] = "bp",
}

for ru_cmd, en_cmd in pairs(cmd_aliases) do
	vim.cmd(string.format(
		[[cnoreabbrev <expr> %s getcmdtype() ==# ':' && getcmdline() ==# '%s' ? '%s' : '%s']],
		ru_cmd,
		ru_cmd,
		en_cmd,
		ru_cmd
	))
end


-- completion popup menu
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

vim.keymap.set("n", "-", "<cmd>Ex<CR>", { desc = "Open netrw" })


-- enable my LSP servers in ~/.config/nvim/lsp/..
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- Get the LSP client that attached to this buffer.
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Small helper for buffer-local keymaps.
    local map = function(mode, keys, action, desc)
      vim.keymap.set(mode, keys, action, {
        buffer = event.buf,
        desc = desc,
      })
    end

    -- Enable builtin completion if the server supports it.
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
      })

      -- Manually trigger the completion popup in insert mode.
      map("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end, "Trigger completion")
    end

    -- Code navigation and symbol actions.
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, "Find references")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format file")

    -- Diagnostics navigation and display.
    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")
  end,
})
