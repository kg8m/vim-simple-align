function simple_align#lines#get(from, to) abort
  return map(range(a:from, a:to), "getline(v:val)")
endfunction
