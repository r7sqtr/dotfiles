return {
  "VidocqH/lsp-lens.nvim",
  event = { "LspAttach" },
  cmd = { "LspLensToggle", "LspLensOn", "LspLensOff" },
  config = function()
    require("lsp-lens").setup({
      enable = true,
      include_declaration = true, -- Reference include declaration
      sections = {
        definition = true,
        references = true,
        implements = false,
        git_authors = false,
      },
    })
  end,
}

