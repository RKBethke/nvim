local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {
    -- b.formatting.prettierd.with { filetypes = { "html", "markdown", "css" } },
    -- b.formatting.deno_fmt,

    -- Lua
    -- Only format if there is a stylua.toml file
    b.formatting.stylua.with({
        condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
        end,
    }),
    -- b.formatting.stylua,
    b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

    -- Shell
    --
    -- b.formatting.shfmt,
    -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local M = {}

M.setup = function()
    null_ls.setup({
        debug = true,
        sources = sources,
    })
end

return M
