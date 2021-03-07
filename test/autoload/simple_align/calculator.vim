let s:assert = themis#helper("assert")

let s:calculate_token_widths = themis#suite("simple_align#calculator#calculate_token_widths")
function s:calculate_token_widths.calculates_each_column_max_width() abort
  let tokens_list = [
  \   ["aaa", "|", "b",  "|", "ccccc", "|", "1234567890"],
  \   ["a",   "|", "bb", "|", "ccccc", "|", "12345"],
  \   ["aa",  "|", "b",  "|", "c",     "|", "123"],
  \ ]
  let expected = [3, 1, 2, 1, 5, 1, 10]

  call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected)
endfunction

function s:calculate_token_widths.calculates_multibyte_character_as_2_width() abort
  let tokens_list = [
  \   ["aaa", "|", "b",  "|", "ccccc", "|", "1234567890"],
  \   ["あ",  "|", "い", "|", "う",    "|", "かきくけこさしすせそ"],
  \ ]
  let expected = [3, 1, 2, 1, 5, 1, 20]

  call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected)
endfunction

function s:calculate_token_widths.calculates_ambiwidth_character_as_1_or_2_width_depending_on_ambiwidth_configuration() abort
  let original_ambiwidth = &ambiwidth

  try
    let tokens_list = [
    \   ["①", "|", "①①", "|", "①①①"],
    \ ]
    let expected_for_single = [1, 1, 2, 1, 3]
    let expected_for_double = [2, 1, 4, 1, 6]

    set ambiwidth=single
    call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected_for_single)

    set ambiwidth=double
    call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected_for_double)
  finally
    let &ambiwidth = original_ambiwidth
  endtry
endfunction

function s:calculate_token_widths.calculates_hard_tab_width_depending_on_tabstop_configuration() abort
  let original_tabstop = &tabstop

  try
    let tokens_list = [
    \   ["\t", "|", "\t\t", "|", "a\ta"],
    \ ]
    let expected_for_2 = [2, 1, 4, 1, 3]
    let expected_for_4 = [4, 1, 8, 1, 5]
    let expected_for_8 = [8, 1, 16, 1, 9]

    set tabstop=2
    call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected_for_2)

    set tabstop=4
    call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected_for_4)

    set tabstop=8
    call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected_for_8)
  finally
    let &tabstop = original_tabstop
  endtry
endfunction

function s:calculate_token_widths.no_problem_even_if_each_element_lenght_of_tokens_list_is_different() abort
  let tokens_list = [
  \   ["aaa", "|", "b",     "|", "ccccc", "|", "1234567890"],
  \   [],
  \   ["x",   "|", "yyyyy", "|", "zzz"],
  \   ["0",   "|", "1",     "|", "2",     "|", "3",          "|", "4"],
  \ ]
  let expected = [3, 1, 5, 1, 5, 1, 10, 1, 1]

  call s:assert.equal(simple_align#calculator#calculate_token_widths(tokens_list), expected)
endfunction
