vim.g.theme = "gruvbox-material"

-- Load theme
require("colors." .. vim.g.theme).setup()

-- Call highlights for specific highlights
require("colors.highlights")
