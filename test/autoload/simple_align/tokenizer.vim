call themis#helper("command")
let s:assert = themis#helper("assert")

let s:LINES =<< trim TXT
  abc | 012345 | あいうえお | ①②③
  --- | --- | --- | ---
  ④ | かきくけこ | def | 6789
  01234 | ⑤⑥ | さしす | ghijk
  lmnopq | 56 | ⑦⑧⑨⑩ | せそ
TXT
let s:DELIMITER = "|"

let s:lines_to_tokens_list = themis#suite("simple_align#tokenizer#lines_to_tokens_list")
function s:lines_to_tokens_list.returns_recursively_splitted_tokens_of_each_line_if_minus_1_count_option_given() abort
  let options = #{ count: -1 }
  let expected = [
  \   ["abc", "|", "012345", "|", "あいうえお", "|", "①②③"],
  \   ["---", "|", "---", "|", "---", "|", "---"],
  \   ["④", "|", "かきくけこ", "|", "def", "|", "6789"],
  \   ["01234", "|", "⑤⑥", "|", "さしす", "|", "ghijk"],
  \   ["lmnopq", "|", "56", "|", "⑦⑧⑨⑩", "|", "せそ"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(s:LINES, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.returns_once_splitted_tokens_of_each_line_if_1_count_option_given() abort
  let options = #{ count: 1 }
  let expected = [
  \   ["abc", "|", "012345 | あいうえお | ①②③"],
  \   ["---", "|", "--- | --- | ---"],
  \   ["④", "|", "かきくけこ | def | 6789"],
  \   ["01234", "|", "⑤⑥ | さしす | ghijk"],
  \   ["lmnopq", "|", "56 | ⑦⑧⑨⑩ | せそ"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(s:LINES, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.returns_twice_splitted_tokens_of_each_line_if_2_count_option_given() abort
  let options = #{ count: 2 }
  let expected = [
  \   ["abc", "|", "012345", "|", "あいうえお | ①②③"],
  \   ["---", "|", "---", "|", "--- | ---"],
  \   ["④", "|", "かきくけこ", "|", "def | 6789"],
  \   ["01234", "|", "⑤⑥", "|", "さしす | ghijk"],
  \   ["lmnopq", "|", "56", "|", "⑦⑧⑨⑩ | せそ"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(s:LINES, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.all_splitted_tokens_are_trimmed() abort
  let lines = [
  \   "      aaaaa            | bbbbbb     |   cccccccccccc       ",
  \   "   ddddddddddddddddddd      |   eeeeeee    |   fffff        ",
  \ ]
  let options = #{ count: -1 }
  let expected = [
  \   ["aaaaa", "|", "bbbbbb", "|", "cccccccccccc"],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.no_problem_even_if_there_are_no_spaces() abort
  let lines =<< trim TXT
    aaaaa|bbbbbb|cccccccccccc
    ddddddddddddddddddd|eeeeeee|fffff
  TXT
  let options = #{ count: -1 }
  let expected = [
  \   ["aaaaa", "|", "bbbbbb", "|", "cccccccccccc"],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.treats_first_token_as_empty_string_if_line_starts_with_delimiter() abort
  let lines =<< trim TXT
    | aaaaa | bbbbbb | cccccccccccc
    ddddddddddddddddddd | eeeeeee | fffff
  TXT
  let options = #{ count: -1 }
  let expected = [
  \   ["", "|", "aaaaa", "|", "bbbbbb", "|", "cccccccccccc"],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.treats_first_token_as_empty_string_if_line_starts_with_spaces_and_delimiter() abort
  let lines = [
  \   "     | aaaaa | bbbbbb | cccccccccccc",
  \   "ddddddddddddddddddd | eeeeeee | fffff",
  \ ]
  let options = #{ count: -1 }
  let expected = [
  \   ["", "|", "aaaaa", "|", "bbbbbb", "|", "cccccccccccc"],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.treats_last_token_as_empty_string_if_line_ends_with_spaces_and_delimiter() abort
  let lines = [
  \   "aaaaa | bbbbbb | cccccccccccc |     ",
  \   "ddddddddddddddddddd | eeeeeee | fffff",
  \ ]
  let options = #{ count: -1 }
  let expected = [
  \   ["aaaaa", "|", "bbbbbb", "|", "cccccccccccc", "|", ""],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.treats_last_token_as_empty_string_if_line_ends_with_delimiter() abort
  let lines =<< trim TXT
    aaaaa | bbbbbb | cccccccccccc |
    ddddddddddddddddddd | eeeeeee | fffff
  TXT
  let options = #{ count: -1 }
  let expected = [
  \   ["aaaaa", "|", "bbbbbb", "|", "cccccccccccc", "|", ""],
  \   ["ddddddddddddddddddd", "|", "eeeeeee", "|", "fffff"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.accepts_regular_expression_delimiter() abort
  let lines =<< trim TXT
    foo = 1
    foo += 2
    foobar = 3
  TXT
  let delimiter = '+\?='
  let options = #{ count: -1 }
  let expected = [
  \   ["foo", "=", "1"],
  \   ["foo", "+=", "2"],
  \   ["foobar", "=", "3"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, delimiter, options), expected)
endfunction

function s:lines_to_tokens_list.no_problem_even_if_each_line_column_number_is_different() abort
  let lines =<< trim TXT
    aaa | bbb | ccc
    ddd | eee
    fff
    ggg | hhh
    iii | jjj | kkk
  TXT
  let options = #{ count: -1 }
  let expected = [
  \   ["aaa", "|", "bbb", "|", "ccc"],
  \   ["ddd", "|", "eee"],
  \   ["fff"],
  \   ["ggg", "|", "hhh"],
  \   ["iii", "|", "jjj", "|", "kkk"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, s:DELIMITER, options), expected)
endfunction

function s:lines_to_tokens_list.does_not_trim_delimiters() abort
  let delimiter = '\s*\d\+\s*'
  let options = #{ count: -1 }
  let expected = [
  \   ["abc |",                   " 012345 ", "| あいうえお | ①②③"],
  \   ["--- | --- | --- | ---"],
  \   ["④ | かきくけこ | def |", " 6789",    ""],
  \   ["",                        "01234 ",   "| ⑤⑥ | さしす | ghijk"],
  \   ["lmnopq |",                " 56 ",     "| ⑦⑧⑨⑩ | せそ"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(s:LINES, delimiter, options), expected)
endfunction

function s:lines_to_tokens_list.is_not_influenced_by_magic_configuration() abort
  let original_magic = &magic

  try
    set nomagic

    let delimiter = '\s*\d\+\s*'
    let options = #{ count: -1 }
    let expected = [
    \   ["abc |",                   " 012345 ", "| あいうえお | ①②③"],
    \   ["--- | --- | --- | ---"],
    \   ["④ | かきくけこ | def |", " 6789",    ""],
    \   ["",                        "01234 ",   "| ⑤⑥ | さしす | ghijk"],
    \   ["lmnopq |",                " 56 ",     "| ⑦⑧⑨⑩ | せそ"],
    \ ]

    call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(s:LINES, delimiter, options), expected)
  finally
    let &magic = original_magic
  endtry
endfunction

function s:lines_to_tokens_list.accepts_very_magic_delimiter_pattern() abort
  let lines = s:LINES
  let options = #{ count: -1 }

  let delimiter = '\v|'

  " E132: Function call depth is higher than 'maxfuncdepth'
  Throws /:E132:/ :call simple_align#tokenizer#lines_to_tokens_list(lines, delimiter, options)

  let delimiter = '\v\|'
  let expected = [
  \   ["abc", "|", "012345", "|", "あいうえお", "|", "①②③"],
  \   ["---", "|", "---", "|", "---", "|", "---"],
  \   ["④", "|", "かきくけこ", "|", "def", "|", "6789"],
  \   ["01234", "|", "⑤⑥", "|", "さしす", "|", "ghijk"],
  \   ["lmnopq", "|", "56", "|", "⑦⑧⑨⑩", "|", "せそ"],
  \ ]

  call s:assert.equal(simple_align#tokenizer#lines_to_tokens_list(lines, delimiter, options), expected)
endfunction
