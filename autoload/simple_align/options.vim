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

export def CompletionCandidates(arglead: string, cmdline: string, curpos: number): list<string>
  const leading_chars       = cmdline[0 : curpos - 1]
  const leading_arg_pattern = arglead ==# "" ? '\v\S+\s+$' : '\v\S+$'
  const leading_arg         = trim(matchstr(leading_chars, leading_arg_pattern))

  if simple_align#options#IsOption(leading_arg)
    const option_name = simple_align#options#ArgumentToName(leading_arg)

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

      if simple_align#options#IsOption(prev_leading_arg)
        const option_name = simple_align#options#ArgumentToName(prev_leading_arg)
        all_candidates = VALUE_CANDIDATES[option_name]
      else
        all_candidates = LIST
      endif

      return filter(copy(all_candidates), (_, candidate) => candidate =~# '^' .. arglead)
    endif
  endif
enddef

export def IsOption(argument: string): bool
  return index(LIST, argument) ># -1
enddef

export def IsValidValue(option_name: string, value: string): bool
  return value =~# VALID_VALUE_PATTERNS[option_name]
enddef

export def IsShortOptionWithValue(argument: string): bool
  if stridx(argument, "-") !=# 0
    return false
  endif

  const short_name = ExtractShortName(argument)

  if has_key(SHORT_NAMES, short_name)
    const name  = ShortNameToLongName(short_name)
    const value = ExtractValueFromShortOptionWithValue(argument)

    return simple_align#options#IsValidValue(name, value)
  else
    return false
  endif
enddef

export def ArgumentToName(argument: string): string
  const name = substitute(argument, '^-\+', "", "")

  if len(name) ==# 1
    return ShortNameToLongName(name)
  else
    return name
  endif
enddef

export def DefaultValues(): dict<string>
  return DEFAULT_VALUES
enddef

export def ExtractNameAndValue(short_option_with_value: string): dict<string>
  const short_name = ExtractShortName(short_option_with_value)
  const long_name  = ShortNameToLongName(short_name)
  const value      = ExtractValueFromShortOptionWithValue(short_option_with_value)

  return { name: long_name, value: value }
enddef

export def NormalizeValue(option_name: string, value: string): any
  const Normalizing = VALUE_NORMALIZINGS[option_name]

  if type(Normalizing) ==# v:t_func
    return Normalizing(value)
  else
    return value
  endif
enddef

def ExtractShortName(argument: string): string
  # `-c777` => `c`
  return strpart(argument, 1, 1)
enddef

def ExtractValueFromShortOptionWithValue(argument: string): string
  # `-c777` => `777`
  return strpart(argument, 2)
enddef

def ShortNameToLongName(short_name: string): string
  return get(SHORT_NAMES, short_name, short_name)
enddef
