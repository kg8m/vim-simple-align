vim9script

const LIST = [
  "-count",
  "-lpadding",
  "-rpadding",
  "-justify",

  "-c",
  "-l",
  "-r",
  "-j",
]

const SHORT_NAMES = {
  c: "count",
  l: "lpadding",
  r: "rpadding",
  j: "justify",
}

const DEFAULT_VALUES = {
  count:    "-1",
  lpadding: "1",
  rpadding: "1",
  justify:  "left",
}

const VALUE_NORMALIZINGS = {
  count:    function("str2nr"),
  lpadding: function("str2nr"),
  rpadding: function("str2nr"),
  justify:  v:null,
}

const VALID_VALUE_PATTERNS = {
  count:    '^-1$\|^[1-9][0-9]*$',
  lpadding: '^[0-9]\+$',
  rpadding: '^[0-9]\+$',
  justify:  '\v^(left|right)$',
}

const VALUE_CANDIDATES = {
  count:    ["-1"] + mapnew(range(1, 9), (_, i) => string(i)),
  lpadding: mapnew(range(0, 9), (_, i) => string(i)),
  rpadding: mapnew(range(0, 9), (_, i) => string(i)),
  justify:  ["left", "right"],
}

def simple_align#options#completion_candidates(arglead: string, cmdline: string, curpos: number): list<string>
  const leading_chars       = cmdline[0 : curpos - 1]
  const leading_arg_pattern = arglead ==# "" ? '\v\S+\s+$' : '\v\S+$'
  const leading_arg         = trim(matchstr(leading_chars, leading_arg_pattern))

  if simple_align#options#is_option(leading_arg)
    const option_name = simple_align#options#argument_to_name(leading_arg)

    if arglead ==# ""
      return VALUE_CANDIDATES[option_name]
    else
      return []
    endif
  else
    if arglead ==# ""
      return LIST
    else
      const prev_leading_arg = trim(matchstr(substitute(leading_chars, '\v\s+\S+$', "", ""), '\v\S+$'))
      var all_candidates: list<string>

      if simple_align#options#is_option(prev_leading_arg)
        const option_name = simple_align#options#argument_to_name(prev_leading_arg)
        all_candidates = VALUE_CANDIDATES[option_name]
      else
        all_candidates = LIST
      endif

      return filter(copy(all_candidates), (_, candidate) => candidate =~# '^' .. arglead)
    endif
  endif
enddef

def simple_align#options#is_option(string: string): bool
  return index(LIST, string) ># -1
enddef

def simple_align#options#is_valid_value(option_name: string, value: string): bool
  return value =~# VALID_VALUE_PATTERNS[option_name]
enddef

def simple_align#options#argument_to_name(argument: string): string
  const name = substitute(argument, '^-\+', "", "")

  if len(name) ==# 1
    return get(SHORT_NAMES, name, name)
  else
    return name
  endif
enddef

def simple_align#options#default_values(): dict<string>
  return DEFAULT_VALUES
enddef

def simple_align#options#normalize_value(option_name: string, value: string): any
  const Normalizing = VALUE_NORMALIZINGS[option_name]

  if type(Normalizing) ==# v:t_func
    return Normalizing(value)
  else
    return value
  endif
enddef
