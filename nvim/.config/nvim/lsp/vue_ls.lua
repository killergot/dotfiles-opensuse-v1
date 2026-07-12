local function global_typescript_sdk_path()
  local global_sdk = vim.env.HOME .. "/.local/lib/node_modules/typescript/lib"
  if vim.uv.fs_stat(global_sdk) then
    return global_sdk
  end
end

local tsdk = global_typescript_sdk_path()

return {
  cmd = tsdk
      and { "vue-language-server", "--stdio", "--tsdk=" .. tsdk }
      or { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = {
    "package.json",
    "vue.config.js",
    "vite.config.js",
    "vite.config.ts",
    "nuxt.config.js",
    "nuxt.config.ts",
    ".git",
  },
}
