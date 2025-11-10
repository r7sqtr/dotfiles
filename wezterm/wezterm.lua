local ui = require("config.ui")
local fonts = require("config.fonts")
local keymap = require("config.keymap")
local colorscheme = require("config.colorscheme")

local config = {}

-- General
config.initial_cols = 170
config.initial_rows = 40

-- Load UI, font, keymap, and colorscheme settings
ui.setup(config)
fonts.setup(config)
keymap.setup(config)
colorscheme.setup(config)

return config
