let s:assert = themis#helper("assert")

let s:get = themis#suite("simple_align#lines#get")
function s:get.returns_list_of_given_range_lines() abort
  let lines =<< trim TXT
    aaaaa
    あああああ
    0000000000
    zzzzzzzzzz
    んんんんんんんんんん
    99999
  TXT
  call setline(1, lines)

  call s:assert.equal(
  \   simple_align#lines#Get(1, 6),
  \   lines,
  \ )

  call s:assert.equal(
  \   simple_align#lines#Get(2, 5),
  \   lines[1 : -2],
  \ )

  call s:assert.equal(
  \   simple_align#lines#Get(3, 4),
  \   lines[2 : -3],
  \ )
endfunction
