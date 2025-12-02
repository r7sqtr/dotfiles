return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  priority = 100,
  opts = {
    enabled = true,
    message_template = "<author>, <date> <summary>",
    date_format = "%Y-%m-%d %H:%M:%S",
    virtual_text_column = 1,
  },
}
