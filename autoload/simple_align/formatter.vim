vim9script

def simple_align#formatter#format(first_lnum: number, tokens_list: list<list<string>>, token_widths: list<number>, options: dict<any>): void
  const cursor     = { lnum: line("."), col: col(".") }
  const lazyredraw = &lazyredraw

  try
    set lazyredraw
    s:_format(first_lnum, tokens_list, token_widths, options)
  finally
    cursor(cursor.lnum, cursor.col)
    &lazyredraw = lazyredraw
  endtry
enddef

def s:_format(firstlnum: number, tokens_list: list<list<string>>, token_widths: list<number>, options: dict<any>): void
  const lastlnum = firstlnum + len(tokens_list) - 1
  const indent   = s:detect_indent(firstlnum, lastlnum)
  const lines    = mapnew(tokens_list, (index, tokens) => s:tokens_to_line(firstlnum + index, indent, tokens, token_widths, options))
  setline(firstlnum, lines)
enddef

def s:detect_indent(firstlnum: number, lastlnum: number): string
  final data = { lnum: 0, indent: -1 }

  for lnum in range(firstlnum, lastlnum)
    if empty(getline(lnum))
      continue
    endif

    const indent = indent(lnum)

    if data.indent ==# -1 || indent <# data.indent
      data.lnum   = lnum
      data.indent = indent
    endif
  endfor

  if data.indent ==# -1
    return ""
  else
    return matchstr(getline(data.lnum), '^\s*')
  endif
enddef

def s:tokens_to_line(lnum: number, indent: string, tokens: list<string>, token_widths: list<number>, options: dict<any>): string
  var line = ""

  if token_widths[0] ># 0
    line ..= s:format_field(tokens[0], token_widths[0], options.justify)
  endif

  const n = len(tokens)
  var i = 1

  while i <# n
    const token = tokens[i]
    const width = token_widths[i]

    var formatted: string
    var is_trimming: bool

    if s:is_delimiter(i)
      const lpadding = i ==# 1     && token_widths[0] ==#  0 ? 0 : options.lpadding
      const rpadding = i ==# n - 2 && token_widths[-1] ==# 0 ? 0 : options.rpadding
      formatted   = s:format_delimiter(token, width, lpadding, rpadding, options.justify)
      is_trimming = (i ==# n - 2) && (token_widths[-1] ==# 0)
    else
      formatted   = s:format_field(token, width, options.justify)
      is_trimming = (i ==# n - 1)
    endif

    if is_trimming
      formatted = substitute(formatted, '\v\s+$', "", "")
    endif

    line ..= formatted
    i += 1
  endwhile

  return indent .. substitute(line, '\s*$', "", "")
enddef

def s:format_field(value: string, width: number, justify: string): string
  const fmt = printf("%%%s%dS", justify ==# "left" ? "-" : "", width)
  return printf(fmt, value)
enddef

def s:format_delimiter(delimiter: string, width: number, lpadding: number, rpadding: number, justify: string): string
  const fmt = printf("%%%ds%%%s%dS%%%ds", lpadding, justify ==# "left" ? "-" : "", width, rpadding)
  return printf(fmt, "", delimiter, "")
enddef

def s:is_delimiter(index: number): bool
  return index % 2 ==# 1
enddef
