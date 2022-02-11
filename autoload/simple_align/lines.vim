vim9script

export def Get(from_lnum: number, to_lnum: number): list<string>
  return mapnew(range(from_lnum, to_lnum), "getline(v:val)")
enddef
