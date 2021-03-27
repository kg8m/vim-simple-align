function simple_align#align(from_lnum, to_lnum, args) abort
  let lines = simple_align#lines#get(a:from_lnum, a:to_lnum)
  let args  = simple_align#parser#parse(a:args)

  if empty(args.delimiter)
    call simple_align#logger#error("Delimiter is not given.")
    return
  endif

  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, args.delimiter, args.options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  call simple_align#formatter#format(a:from_lnum, tokens_list, token_widths, args.options)
endfunction
