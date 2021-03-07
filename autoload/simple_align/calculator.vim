function simple_align#calculator#calculate_token_widths(tokens_list) abort
  let widths = []

  for tokens in a:tokens_list
    let token_widths = tokens->copy()->map("strdisplaywidth(v:val)")
    let n = len(token_widths)
    let i = 0

    while i <# n
      let current_width = get(widths, i, -1)

      if current_width >=# 0
        call remove(widths, i)
      endif

      call insert(widths, max([token_widths[i], current_width]), i)

      let i += 1
    endwhile
  endfor

  return widths
endfunction
