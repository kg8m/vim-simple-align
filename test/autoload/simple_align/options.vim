call themis#helper("command")
let s:assert = themis#helper("assert")

let s:completion_candidates = themis#suite("simple_align#options#completion_candidates")
function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_empty() abort
  let cmdline = "'<,'>SimpleAlign "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -lpadding 0 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_single_hyphen() abort
  let cmdline = "'<,'>SimpleAlign -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_matched_options_if_arglead_is_single_hyphens_and_a_char() abort
  for cmdline_prefix in ["'<,'>SimpleAlign ", "'<,'>SimpleAlign -count 1 "]
    let cmdline = cmdline_prefix .. "-c"
    let curpos  = strwidth(cmdline)
    let arglead = "-c"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-l"
    let curpos  = strwidth(cmdline)
    let arglead = "-l"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-r"
    let curpos  = strwidth(cmdline)
    let arglead = "-r"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-j"
    let curpos  = strwidth(cmdline)
    let arglead = "-j"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-a"
    let curpos  = strwidth(cmdline)
    let arglead = "-a"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "--"
    let curpos  = strwidth(cmdline)
    let arglead = "--"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )
  endfor
endfunction

function s:completion_candidates.returns_list_of_matched_options_if_arglead_is_single_hyphens_and_2_chars() abort
  for cmdline_prefix in ["'<,'>SimpleAlign ", "'<,'>SimpleAlign -count 1 "]
    let cmdline = cmdline_prefix .. "-co"
    let curpos  = strwidth(cmdline)
    let arglead = "-co"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-count"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-lp"
    let curpos  = strwidth(cmdline)
    let arglead = "-lp"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-lpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-rp"
    let curpos  = strwidth(cmdline)
    let arglead = "-rp"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-rpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-ju"
    let curpos  = strwidth(cmdline)
    let arglead = "-ju"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-justify"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-ab"
    let curpos  = strwidth(cmdline)
    let arglead = "-ab"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "--x"
    let curpos  = strwidth(cmdline)
    let arglead = "--x"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )
  endfor
endfunction

function s:completion_candidates.returns_empty_list_if_arglead_is_chars_starting_with_non_hyphen() abort
  for cmdline_prefix in ["'<,'>SimpleAlign ", "'<,'>SimpleAlign -count 1 "]
    for arglead in ["c", "l", "r", "j", "a"]
      let cmdline = cmdline_prefix .. arglead
      let curpos  = strwidth(cmdline)
      call s:assert.equal(
      \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
      \   [],
      \   "cmdline_prefix: " .. string(cmdline_prefix) .. ", arglead: " .. string(arglead),
      \ )
    endfor
  endfor
endfunction

function s:completion_candidates.returns_list_of_option_values_if_leading_argument_is_long_option() abort
  let arglead = ""

  let cmdline = "'<,'>SimpleAlign -count "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-1", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -lpadding "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -justify "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["left", "right"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_option_values_if_leading_argument_is_short_option() abort
  let arglead = ""

  let cmdline = "'<,'>SimpleAlign -c "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-1", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -c 1 -l "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -c 1 -j "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["left", "right"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_matched_option_values_if_prev_leading_argument_is_option() abort
  let cmdline = "'<,'>SimpleAlign -count -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-1"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -justify l"
  let curpos  = strwidth(cmdline)
  let arglead = "l"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["left"],
  \ )
endfunction

let s:is_option = themis#suite("simple_align#options#is_option")
function s:is_option.returns_true_for_valid_option_argument() abort
  let arguments = [
  \   "-count",
  \   "-lpadding",
  \   "-rpadding",
  \   "-justify",
  \   "-c",
  \   "-l",
  \   "-r",
  \   "-j",
  \ ]

  for argument in arguments
    call s:assert.true(
    \   simple_align#options#is_option(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

function s:is_option.returns_false_for_invalid_option_argument() abort
  let arguments = [
  \   "",
  \   "-",
  \   "-x",
  \   "1",
  \   "count",
  \   "lpadding",
  \   "rpadding",
  \   "justify",
  \   "unknown",
  \ ]

  for argument in arguments
    call s:assert.false(
    \   simple_align#options#is_option(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

let s:is_valid_value = themis#suite("simple_align#options#is_valid_value")
function s:is_valid_value.returns_true_for_valid_option_name_and_value() abort
  let testcases = [
  \   #{ option_name: "count", value: "-1" },
  \   #{ option_name: "count", value: "1" },
  \   #{ option_name: "count", value: "2" },
  \   #{ option_name: "count", value: "9" },
  \   #{ option_name: "count", value: "10" },
  \   #{ option_name: "count", value: "111" },
  \
  \   #{ option_name: "lpadding", value: "0" },
  \   #{ option_name: "lpadding", value: "11" },
  \
  \   #{ option_name: "rpadding", value: "0" },
  \   #{ option_name: "rpadding", value: "222" },
  \ ]

  for testcase in testcases
    call s:assert.true(
    \   simple_align#options#is_valid_value(testcase.option_name, testcase.value),
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:is_valid_value.returns_false_for_valid_option_name_and_invalid_value() abort
  let testcases = [
  \   #{ option_name: "count", value: "-2" },
  \   #{ option_name: "count", value: "0" },
  \   #{ option_name: "count", value: "1.5" },
  \   #{ option_name: "count", value: "-" },
  \   #{ option_name: "count", value: "" },
  \
  \   #{ option_name: "lpadding", value: "-11" },
  \   #{ option_name: "lpadding", value: "1.2" },
  \   #{ option_name: "lpadding", value: "a" },
  \   #{ option_name: "lpadding", value: "" },
  \
  \   #{ option_name: "rpadding", value: "-222" },
  \   #{ option_name: "rpadding", value: "1.7" },
  \   #{ option_name: "rpadding", value: "あああ" },
  \   #{ option_name: "rpadding", value: "" },
  \ ]

  for testcase in testcases
    call s:assert.false(
    \   simple_align#options#is_valid_value(testcase.option_name, testcase.value),
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:is_valid_value.throws_error_for_invalid_option_name_and_valid_value() abort
  let testcases = [
  \   #{ option_name: "",       value: "0" },
  \   #{ option_name: "-count", value: "1" },
  \   #{ option_name: "coun",   value: "0" },
  \ ]

  for testcase in testcases
    try
      " E716: Key not present in Dictionary
      Throws /:E716:/ :call simple_align#options#is_valid_value(testcase.option_name, testcase.value)
    catch
      throw v:exception .. "\n\ntestcase: " .. string(testcase)
    endtry
  endfor
endfunction

let s:argument_to_name = themis#suite("simple_align#options#argument_to_name")
function s:argument_to_name.converts_short_name_to_long_one() abort
  let testcases = [
  \   #{ argument: "-c", expected: "count" },
  \   #{ argument: "c",  expected: "count" },
  \   #{ argument: "c-", expected: "c-" },
  \   #{ argument: "a",  expected: "a" },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#argument_to_name(testcase.argument),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:argument_to_name.trims_leading_hyphens() abort
  let testcases = [
  \   #{ argument: "-count", expected: "count" },
  \   #{ argument: "count",  expected: "count" },
  \   #{ argument: "count-", expected: "count-" },
  \   #{ argument: "",       expected: "" },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#argument_to_name(testcase.argument),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

let s:normalize_value = themis#suite("simple_align#options#normalize_value")
function s:normalize_value.normalize_option_value() abort
  let testcases = [
  \   #{ option_name: "count",    value: "-1",    expected: -1 },
  \   #{ option_name: "count",    value: "1",     expected: 1 },
  \   #{ option_name: "count",    value: "22",    expected: 22 },
  \   #{ option_name: "lpadding", value: "0",     expected: 0 },
  \   #{ option_name: "lpadding", value: "2",     expected: 2 },
  \   #{ option_name: "rpadding", value: "0",     expected: 0 },
  \   #{ option_name: "rpadding", value: "3",     expected: 3 },
  \   #{ option_name: "justify",  value: "left",  expected: "left" },
  \   #{ option_name: "justify",  value: "right", expected: "right" },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#normalize_value(testcase.option_name, testcase.value),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:normalize_value.throws_error_if_option_name_is_invalid() abort
  let testcases = [
  \   #{ option_name: "",  value: "-1" },
  \   #{ option_name: "-", value: "1" },
  \   #{ option_name: "c", value: "22" },
  \   #{ option_name: "l", value: "0" },
  \   #{ option_name: "r", value: "2" },
  \   #{ option_name: "j", value: "left" },
  \ ]

  for testcase in testcases
    try
      " E716: Key not present in Dictionary
      Throws /:E716:/ :call simple_align#options#normalize_value(testcase.option_name, testcase.value)
    catch
      throw v:exception .. "\n\ntestcase: " .. string(testcase)
    endtry
  endfor
endfunction

function s:normalize_value.returns_invalid_value_if_value_is_invalid() abort
  let testcases = [
  \   #{ option_name: "count",    value: "",    expected: 0 },
  \   #{ option_name: "count",    value: "x",   expected: 0 },
  \   #{ option_name: "count",    value: "-2",  expected: -2 },
  \   #{ option_name: "count",    value: ".",   expected: 0 },
  \   #{ option_name: "lpadding", value: "",    expected: 0 },
  \   #{ option_name: "lpadding", value: "x",   expected: 0 },
  \   #{ option_name: "lpadding", value: "-1",  expected: -1 },
  \   #{ option_name: "rpadding", value: "",    expected: 0 },
  \   #{ option_name: "rpadding", value: "x",   expected: 0 },
  \   #{ option_name: "rpadding", value: "1.5", expected: 1 },
  \   #{ option_name: "justify",  value: "x",   expected: "x" },
  \   #{ option_name: "justify",  value: "1",   expected: "1" },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#normalize_value(testcase.option_name, testcase.value),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction
