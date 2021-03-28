vim9script

def simple_align#calculator#calculate_token_widths(tokens_list: list<list<string>>): list<number>
  final widths = []

  for tokens in tokens_list
    const token_widths = mapnew(tokens, "strdisplaywidth(v:val)")
    const n = len(token_widths)
    var i = 0

    while i <# n
      const current_width = get(widths, i, -1)

      if current_width >=# 0
        remove(widths, i)
      endif

      insert(widths, max([token_widths[i], current_width]), i)

      i += 1
    endwhile
  endfor

  return widths
enddef
