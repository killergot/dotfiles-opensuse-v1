local function global_tsserver_path()
  local tsserver = vim.env.HOME .. "/.local/lib/node_modules/typescript/lib/tsserver.js"
  if vim.uv.fs_stat(tsserver) then
    return tsserver
  end
end

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
  },
  init_options = {
    tsserver = {
      path = global_tsserver_path(),
    },
  },
}
