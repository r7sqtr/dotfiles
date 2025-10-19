local ui = require("config.ui")
local fonts = require("config.fonts")
local config = {}

-- General
config.initial_cols = 170
config.initial_rows = 40

-- Load UI and font settings
ui.setup(config)
fonts.setup(config)

return config
