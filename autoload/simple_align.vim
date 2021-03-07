function simple_align#align(args) abort
  if line(".") ==# a:firstline
    let lines = simple_align#lines#get(a:firstline, a:lastline)
    let args  = simple_align#parser#parse(a:args)

    if empty(args.delimiter)
      call simple_align#logger#error("Delimiter is not given.")
      return
    endif

    let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, args.delimiter, args.options)
    let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

    call simple_align#formatter#format(a:firstline, tokens_list, token_widths, args.options)
  endif
endfunction
