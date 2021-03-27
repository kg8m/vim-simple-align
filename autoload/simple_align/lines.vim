function simple_align#lines#get(from_lnum, to_lnum) abort
  return map(range(a:from_lnum, a:to_lnum), "getline(v:val)")
endfunction
