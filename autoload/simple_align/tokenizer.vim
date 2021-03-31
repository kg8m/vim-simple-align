function simple_align#tokenizer#lines_to_tokens_list(lines, delimiter, options) abort
  return map(copy(a:lines), "s:line_to_tokens(v:val, a:delimiter, a:options)")
endfunction

function s:line_to_tokens(line, delimiter, options) abort
  return s:split(trim(a:line), a:delimiter, #{ count: a:options.count })
endfunction

function s:split(line, delimiter, options) abort
  let matchpos    = matchstrpos(a:line, a:delimiter)
  let delimiter   = matchpos[0]
  let start_index = matchpos[1]
  let end_index   = matchpos[2]

  if start_index ==# -1
    return [a:line]
  else
    if start_index ==# 0
      let lhs = ""
      let rhs = a:line[end_index : -1]
    else
      let lhs = a:line[0 : start_index - 1]
      let rhs = a:line[end_index : -1]
    endif

    let lhs = trim(lhs)
    let rhs = trim(rhs)

    if a:options.count ==# 1
      return [lhs, delimiter, rhs]
    elseif a:options.count ># 1
      return [lhs, delimiter] + s:split(rhs, a:delimiter, #{ count: a:options.count - 1 })
    else
      return [lhs, delimiter] + s:split(rhs, a:delimiter, a:options)
    endif
  endif
endfunction
