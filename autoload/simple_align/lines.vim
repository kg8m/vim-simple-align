vim9script

export def Get(from_lnum: number, to_lnum: number): list<string>
  return getline(from_lnum, to_lnum)
enddef
