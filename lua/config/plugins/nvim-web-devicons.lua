local M = {
	"kyazdani42/nvim-web-devicons",
}

function M.config()
	local icons = require("nvim-web-devicons")
	local colors = require("config.plugins.gruvbox-material").colors

	icons.setup({
		override = {
			c = {
				icon = "",
				color = colors.blue,
				name = "c",
			},
			css = {
				icon = "",
				color = colors.blue,
				name = "css",
			},
			deb = {
				icon = "",
				color = colors.cyan,
				name = "deb",
			},
			Dockerfile = {
				icon = "",
				color = colors.cyan,
				name = "Dockerfile",
			},
			html = {
				icon = "",
				color = colors.magenta,
				name = "html",
			},
			jpeg = {
				icon = "",
				color = colors.magenta,
				name = "jpeg",
			},
			jpg = {
				icon = "",
				color = colors.magenta,
				name = "jpg",
			},
			js = {
				icon = "",
				color = colors.yellow,
				name = "js",
			},
			kt = {
				icon = "󱈙",
				color = colors.orange,
				name = "kt",
			},
			lock = {
				icon = "",
				color = colors.red,
				name = "lock",
			},
			lua = {
				icon = "",
				color = colors.blue,
				name = "lua",
			},
			mp3 = {
				icon = "",
				color = colors.fg,
				name = "mp3",
			},
			mp4 = {
				icon = "",
				color = colors.fg,
				name = "mp4",
			},
			out = {
				icon = "",
				color = colors.fg,
				name = "out",
			},
			png = {
				icon = "",
				color = colors.magenta,
				name = "png",
			},
			py = {
				icon = "",
				color = colors.cyan,
				name = "py",
			},
			["robots.txt"] = {
				icon = "ﮧ",
				color = colors.red,
				name = "robots",
			},
			toml = {
				icon = "",
				color = colors.blue,
				name = "toml",
			},
			ts = {
				icon = "ﯤ",
				color = colors.cyan,
				name = "ts",
			},
			ttf = {
				icon = "",
				color = colors.fg,
				name = "TrueTypeFont",
			},
			rb = {
				icon = "",
				color = colors.magenta,
				name = "rb",
			},
			rpm = {
				icon = "",
				color = colors.orange,
				name = "rpm",
			},
			vue = {
				icon = "﵂",
				color = colors.accent,
				name = "vue",
			},
			woff = {
				icon = "",
				color = colors.fg,
				name = "WebOpenFontFormat",
			},
			woff2 = {
				icon = "",
				color = colors.fg,
				name = "WebOpenFontFormat2",
			},
			xz = {
				icon = "",
				color = colors.yellow,
				name = "xz",
			},
			zip = {
				icon = "",
				color = colors.yellow,
				name = "zip",
			},
		},
	})
end

return M
