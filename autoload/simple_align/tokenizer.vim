vim9script

export def LinesToTokensList(lines: list<string>, delimiter: string, options: dict<any>): list<list<string>>
  return mapnew(lines, (_, line) => LineToTokens(line, delimiter, options))
enddef

def LineToTokens(line: string, delimiter: string, options: dict<any>): list<string>
  return Split(trim(line), delimiter, { count: options.count })
enddef

def Split(line: string, delimiter: string, options: dict<any>): list<string>
  const matchpos          = matchstrpos(line, delimiter)
  const matched_delimiter = matchpos[0]
  const start_index       = matchpos[1]
  const end_index         = matchpos[2]

  if start_index ==# -1
    return [line]
  else
    var lhs: string
    var rhs: string

    if start_index ==# 0
      lhs = ""
      rhs = strpart(line, end_index)
    else
      lhs = strpart(line, 0, start_index)
      rhs = strpart(line, end_index)
    endif

    lhs = trim(lhs)
    rhs = trim(rhs)

    if options.count ==# 1
      return [lhs, matched_delimiter, rhs]
    elseif options.count ># 1
      return [lhs, matched_delimiter] + Split(rhs, delimiter, { count: options.count - 1 })
    else
      return [lhs, matched_delimiter] + Split(rhs, delimiter, options)
    endif
  endif
enddef
