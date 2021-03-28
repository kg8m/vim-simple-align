vim9script

def simple_align#align(from_lnum: number, to_lnum: number, args: list<string>): void
  const lines  = simple_align#lines#get(from_lnum, to_lnum)
  const parsed = simple_align#parser#parse(args)

  if empty(parsed.delimiter)
    simple_align#logger#error("Delimiter is not given.")
    return
  endif

  const tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, parsed.delimiter, parsed.options)
  const token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  simple_align#formatter#format(from_lnum, tokens_list, token_widths, parsed.options)
enddef
