call themis#helper("command")
let s:assert = themis#helper("assert")

let s:completion_candidates = themis#suite("simple_align#options#completion_candidates")
function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_empty() abort
  let cmdline = "'<,'>SimpleAlign "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -lpadding 0 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_single_hyphen() abort
  let cmdline = "'<,'>SimpleAlign -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_matched_options_if_arglead_is_single_hyphens_and_a_char() abort
  for cmdline_prefix in ["'<,'>SimpleAlign ", "'<,'>SimpleAlign -count 1 "]
    let cmdline = cmdline_prefix .. "-c"
    let curpos  = strwidth(cmdline)
    let arglead = "-c"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-count"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-l"
    let curpos  = strwidth(cmdline)
    let arglead = "-l"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-lpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-r"
    let curpos  = strwidth(cmdline)
    let arglead = "-r"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-rpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-j"
    let curpos  = strwidth(cmdline)
    let arglead = "-j"
    call s:assert.equal(
    \   simple_align#options#completion_candidates(arglead, cmdline, curpos),
    \   ["-justify"],
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

function s:completion_candidates.returns_list_of_option_values_if_leading_argument_is_option() abort
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
function s:is_option.returns_true_for_valid_option_string() abort
  let option_names = [
  \   "-count",
  \   "-lpadding",
  \   "-rpadding",
  \ ]

  for option_name in option_names
    call s:assert.true(
    \   simple_align#options#is_option(option_name),
    \   "option_name: " .. option_name,
    \ )
  endfor
endfunction

function s:is_option.returns_false_for_invalid_option_string() abort
  let option_names = [
  \   "",
  \   "-",
  \   "1",
  \   "count",
  \   "lpadding",
  \   "rpadding",
  \   "unknown",
  \ ]

  for option_name in option_names
    call s:assert.false(
    \   simple_align#options#is_option(option_name),
    \   "option_name: " .. option_name,
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
