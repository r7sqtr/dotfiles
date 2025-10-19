if vim.g.neovide == true then
  vim.o.guifont = "PlemolJP:h17"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_opacity = 0.8
  vim.g.transparency = 0.8
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_refresh_rate = 144
  vim.opt.linespace = 0
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_floating_blur_amount_x = 0.1
  vim.g.neovide_floating_blur_amount_y = 0.1
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.keymap.set(
    "n",
    "<c-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<cr>",
    { silent = true }
  )
  vim.keymap.set(
    "n",
    "<c-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<cr>",
    { silent = true }
  )
  vim.keymap.set("n", "<c-0>", ":lua vim.g.neovide_scale_factor = 1<cr>", { silent = true })

  -- allow clipboard copy paste in neovim
  -- https://github.com/neovide/neovide/issues/1263#issuecomment-1100895622
  vim.g.neovide_input_use_logo = 1
  vim.keymap.set("", "<d-v>", "+p<cr>", { noremap = true, silent = true })
  vim.keymap.set("!", "<d-v>", "<c-r>+", { noremap = true, silent = true })
  vim.keymap.set("t", "<d-v>", "<c-r>+", { noremap = true, silent = true })
  vim.keymap.set("v", "<d-v>", "<c-r>+", { noremap = true, silent = true })

  ---- IMEの設定
  local function set_ime(args)
    if args.event:match("Enter$") then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime,
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime,
  })
end
