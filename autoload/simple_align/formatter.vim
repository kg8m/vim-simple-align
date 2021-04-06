function simple_align#formatter#format(firstlnum, tokens_list, token_widths, options) abort
  let cursor     = #{ lnum: line("."), col: col(".") }
  let lazyredraw = &lazyredraw

  try
    set lazyredraw
    call s:format(a:firstlnum, a:tokens_list, a:token_widths, a:options)
  finally
    call cursor(cursor.lnum, cursor.col)
    let &lazyredraw = lazyredraw
  endtry
endfunction

function s:format(firstlnum, tokens_list, token_widths, options) abort
  let lastlnum = a:firstlnum + len(a:tokens_list) - 1
  let indent   = s:detect_indent(a:firstlnum, lastlnum)
  let lines    = map(copy(a:tokens_list), "s:tokens_to_line(a:firstlnum + v:key, indent, v:val, a:token_widths, a:options)")

  call setline(a:firstlnum, lines)
endfunction

function s:detect_indent(firstlnum, lastlnum) abort
  let data = #{ lnum: 0, indent: -1 }

  for lnum in range(a:firstlnum, a:lastlnum)
    if empty(getline(lnum))
      continue
    endif

    let indent = indent(lnum)

    if data.indent ==# -1 || indent <# data.indent
      let data.lnum   = lnum
      let data.indent = indent
    endif
  endfor

  if data.indent ==# -1
    return ""
  else
    return matchstr(getline(data.lnum), '^\s*')
  endif
endfunction

function s:tokens_to_line(lnum, indent, tokens, token_widths, options) abort
  let line = ""

  if a:token_widths[0] ># 0
    let line ..= s:format_field(a:tokens[0], a:token_widths[0], a:options.justify)
  endif

  let n = len(a:tokens)
  let i = 1

  while i <# n
    let token = a:tokens[i]
    let width = a:token_widths[i]

    if s:is_delimiter(i)
      let lpadding    = i ==# 1     && a:token_widths[0] ==#  0 ? 0 : a:options.lpadding
      let rpadding    = i ==# n - 2 && a:token_widths[-1] ==# 0 ? 0 : a:options.rpadding
      let formatted   = s:format_delimiter(token, width, lpadding, rpadding, a:options.justify)
      let is_trimming = (i ==# n - 2) && (a:token_widths[-1] ==# 0)
    else
      let formatted   = s:format_field(token, width, a:options.justify)
      let is_trimming = (i ==# n - 1)
    endif

    if is_trimming
      let formatted = substitute(formatted, '\v\s+$', "", "")
    endif

    let line ..= formatted
    let i += 1
  endwhile

  return a:indent .. substitute(line, '\s*$', "", "")
endfunction

function s:format_field(value, width, justify) abort
  let format = printf("%%%s%dS", a:justify ==# "left" ? "-" : "", a:width)
  return printf(format, a:value)
endfunction

function s:format_delimiter(delimiter, width, lpadding, rpadding, justify) abort
  let format = printf("%%%ds%%%s%dS%%%ds", a:lpadding, a:justify ==# "left" ? "-" : "", a:width, a:rpadding)
  return printf(format, "", a:delimiter, "")
endfunction

function s:is_delimiter(index) abort
  return a:index % 2 ==# 1
endfunction
