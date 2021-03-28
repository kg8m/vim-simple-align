vim9script

def simple_align#logger#debug(...messages: list<string>): void
  echomsg "[simple-align] DEBUG - " .. join(mapnew(messages, (_, message) => string(message)), " ")
enddef

def simple_align#logger#info(...messages: list<string>): void
  echomsg "[simple-align] INFO - " .. join(messages, " ")
enddef

def simple_align#logger#error(...messages: list<string>): void
  echohl ErrorMsg
  echomsg "[simple-align] ERROR - " .. join(messages, " ")
  echohl None
enddef
