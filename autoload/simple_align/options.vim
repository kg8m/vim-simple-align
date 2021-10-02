let s:LIST = [
\   "-count",
\   "-lpadding",
\   "-rpadding",
\   "-justify",
\
\   "-c",
\   "-l",
\   "-r",
\   "-j",
\ ]

let s:SHORT_NAMES = #{
\   c: "count",
\   l: "lpadding",
\   r: "rpadding",
\   j: "justify",
\ }

let s:DEFAULT_VALUES = #{
\   count:    "-1",
\   lpadding: "1",
\   rpadding: "1",
\   justify:  "left",
\ }

let s:VALUE_NORMALIZINGS = #{
\   count:    function("str2nr"),
\   lpadding: function("str2nr"),
\   rpadding: function("str2nr"),
\   justify:  v:null,
\ }

let s:VALID_VALUE_PATTERNS = #{
\   count:    '^-1$\|^[1-9][0-9]*$',
\   lpadding: '^[0-9]\+$',
\   rpadding: '^[0-9]\+$',
\   justify:  '\v^(left|right)$',
\ }

let s:VALUE_CANDIDATES = #{
\   count:    ["-1"] + map(range(1, 9), "string(v:val)"),
\   lpadding: map(range(0, 9), "string(v:val)"),
\   rpadding: map(range(0, 9), "string(v:val)"),
\   justify:  ["left", "right"],
\ }

function simple_align#options#completion_candidates(arglead, cmdline, curpos) abort
  let leading_chars       = a:cmdline[0 : a:curpos - 1]
  let leading_arg_pattern = a:arglead ==# "" ? '\v\S+\s+$' : '\v\S+$'
  let leading_arg         = trim(matchstr(leading_chars, leading_arg_pattern))

  if simple_align#options#is_option(leading_arg)
    let option_name = simple_align#options#argument_to_name(leading_arg)

    if a:arglead ==# ""
      return s:VALUE_CANDIDATES[option_name]
    else
      return []
    endif
  else
    if a:arglead ==# ""
      return s:LIST
    else
      let prev_leading_arg = trim(matchstr(substitute(leading_chars, '\v\s+\S+$', "", ""), '\v\S+$'))

      if simple_align#options#is_option(prev_leading_arg)
        let option_name    = simple_align#options#argument_to_name(prev_leading_arg)
        let all_candidates = s:VALUE_CANDIDATES[option_name]
      else
        let all_candidates = s:LIST
      endif

      return filter(copy(all_candidates), "v:val =~# '^' .. a:arglead")
    endif
  endif
endfunction

function simple_align#options#is_option(string) abort
  return index(s:LIST, a:string) ># -1
endfunction

function simple_align#options#is_valid_value(option_name, value) abort
  return a:value =~# s:VALID_VALUE_PATTERNS[a:option_name]
endfunction

function simple_align#options#argument_to_name(argument) abort
  let name = substitute(a:argument, '^-\+', "", "")

  if len(name) ==# 1
    return get(s:SHORT_NAMES, name, name)
  else
    return name
  endif
endfunction

function simple_align#options#default_values() abort
  return s:DEFAULT_VALUES
endfunction

function simple_align#options#normalize_value(option_name, value) abort
  let Normalizing = s:VALUE_NORMALIZINGS[a:option_name]

  if type(Normalizing) ==# v:t_func
    return Normalizing(a:value)
  else
    return a:value
  endif
endfunction
