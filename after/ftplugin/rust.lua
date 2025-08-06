vim.bo.textwidth = 100
vim.bo.errorformat = table.concat({
	"%-G%.%#aborting due to previous error%.%#", -- ignore “aborting due to previous error” :contentReference[oaicite:6]{index=6}
	"%-G%.%#test failed, to rerun pass%.%#", -- ignore test hints :contentReference[oaicite:7]{index=7}
	"%D%*\\sDoc-tests %f%.%#", -- doc-test file entries :contentReference[oaicite:8]{index=8}
	"%E---- %f - %o (line %l) stdout ----,", -- doc-test header :contentReference[oaicite:9]{index=9}
	"%Cerror%m,", -- doc-test error message :contentReference[oaicite:10]{index=10}
	"%-Z%*\\s--> %f:%l:%c,", -- file:line:column info :contentReference[oaicite:11]{index=11}
	"%Eerror%m,", -- compiler errors :contentReference[oaicite:12]{index=12}
	"%Wwarning: %m,", -- compiler warnings :contentReference[oaicite:13]{index=13}
	"%-Z%*\\s--> %f:%l:%c,", -- file info continuation :contentReference[oaicite:14]{index=14}
	"%C%m", -- continuation lines :contentReference[oaicite:15]{index=15}
}, ",")
