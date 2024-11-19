if exists("b:did_indent") | finish | en
let b:did_indent = 1

setl indentkeys+=0=} autoindent indentexpr=GetRhoIndent()

fun! GetRhoIndent()
    let prevlnum = prevnonblank(v:lnum - 1)
    if prevlnum == 0 | retu 0 | en

    " Add a 'shiftwidth' after lines that start a block: '{'
    let ind = indent(prevlnum)
    let prevline = getline(prevlnum)
    let midx = match(prevline, '[({]\s*$')
    if midx != -1
	let ind += &sw
    en

    " Subtract a 'shiftwidth' on '}'.
    let midx = match(getline(v:lnum), '^\s*\%([}]\)')
    if midx != -1
	let ind -= &sw
    en

    retu ind
endf
