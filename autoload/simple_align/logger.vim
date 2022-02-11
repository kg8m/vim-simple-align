vim9script

export def Debug(...messages: list<string>): void
  echomsg "[simple-align] DEBUG - " .. join(mapnew(messages, (_, message) => string(message)), " ")
enddef

export def Info(...messages: list<string>): void
  echomsg "[simple-align] INFO - " .. join(messages, " ")
enddef

export def Error(...messages: list<string>): void
  echohl ErrorMsg
  echomsg "[simple-align] ERROR - " .. join(messages, " ")
  echohl None
enddef
