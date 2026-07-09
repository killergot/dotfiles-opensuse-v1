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

local function open_help_menu(title, lines)
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  width = math.min(math.max(width + 4, 46), vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 6)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true

  local close = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, desc = "Close help" })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true, desc = "Close help" })
end

local function open_lsp_help()
  open_help_menu("LSP help", {
    "LSP: навигация и действия",
    "",
    "gd          definition: перейти к определению",
    "gD          declaration: перейти к объявлению",
    "gi          implementation: перейти к реализации",
    "gr          references: найти использования",
    "K           hover: документация под курсором",
    "<leader>rn rename symbol",
    "<leader>ca code action / quick fix",
    "<leader>ds document symbols",
    "<leader>f  format file через LSP",
    "",
    "Diagnostics",
    "<leader>e  показать ошибку под курсором",
    "]d / [d     следующая / предыдущая diagnostic",
    "<leader>q  diagnostics в location list",
    "",
    "Completion",
    "<C-Space>  вручную открыть completion",
    "<C-n>/<C-p> выбрать следующий / предыдущий пункт",
    "<C-y>      подтвердить выбранный пункт",
    "",
    "Проверка состояния",
    ":checkhealth vim.lsp",
    ":lua vim.print(vim.lsp.get_clients({bufnr=0}))",
    "",
    "q или Esc закрыть это окно",
  })
end

local function open_vim_help()
  open_help_menu("Vim help", {
    "Vim: полезное, что легко забыть",
    "",
    "Macros",
    "qa          начать запись macro в регистр a",
    "q           остановить запись macro",
    "@a          выполнить macro из регистра a",
    "@@          повторить последнюю macro",
    "10@a        выполнить macro 10 раз",
    "",
    "Repeat / undo",
    ".           повторить последнее изменение",
    "u / <C-r>   undo / redo",
    "",
    "Registers",
    "\"0p         вставить последний yank",
    "\"_d         удалить без записи в register",
    "\"+y / \"+p   yank / paste через системный clipboard",
    ":reg        посмотреть registers",
    "",
    "Marks and jumps",
    "ma          поставить mark a",
    "'a / `a     перейти к строке mark / точной позиции",
    "''          вернуться к прошлой позиции",
    "<C-o>/<C-i> назад / вперёд по jump list",
    ":jumps      посмотреть jump list",
    "",
    "Text objects",
    "ci\"         изменить внутри кавычек",
    "da)         удалить скобки вместе с содержимым",
    "vit         выделить внутри HTML/XML tag",
    "",
    "Search / replace",
    "* / #       искать слово под курсором вперёд / назад",
    ":%s/a/b/gc  заменить с подтверждением",
    ":noh        убрать подсветку поиска",
    "",
    "Windows / lists",
    "<C-w>s/v    split horizontal / vertical",
    "<C-w>h/j/k/l перейти между окнами",
    ":copen      quickfix list",
    ":lopen      location list",
    "",
    "q или Esc закрыть это окно",
  })
end

vim.keymap.set("n", "<leader>?", open_vim_help, { desc = "Show Vim help" })
vim.keymap.set("n", "<leader>L", open_lsp_help, { desc = "Show LSP help" })
vim.api.nvim_create_user_command("VimHelpMenu", open_vim_help, {})
vim.api.nvim_create_user_command("LspHelpMenu", open_lsp_help, {})


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
