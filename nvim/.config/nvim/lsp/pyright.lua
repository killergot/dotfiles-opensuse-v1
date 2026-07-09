return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },

  before_init = function(_, config)
    local venv = vim.fs.find(".venv", {
      path = config.root_dir,
      upward = true,
      type = "directory",
    })[1]

    if venv then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = venv .. "/bin/python"
    end
  end,
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
}
