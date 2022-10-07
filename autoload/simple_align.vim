vim9script

export def Align(from_lnum: number, to_lnum: number, args: list<string>): void
  const lines = simple_align#lines#Get(from_lnum, to_lnum)
  # FIXME: `: dict<any>` is a workaround for preventing an error `E1229: Expected dictionary for using key "delimiter)",
  # but got any`, that may be Vim9 script's bug.
  const parsed: dict<any> = simple_align#parser#Parse(args)

  if empty(parsed.delimiter)
    simple_align#logger#Error("Delimiter is not given.")
    return
  endif

  const tokens_list  = simple_align#tokenizer#LinesToTokensList(lines, parsed.delimiter, parsed.options)
  const token_widths = simple_align#calculator#CalculateTokenWidths(tokens_list)

  simple_align#formatter#Format(from_lnum, tokens_list, token_widths, parsed.options)
enddef
