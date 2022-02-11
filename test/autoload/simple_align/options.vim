call themis#helper("command")
let s:assert = themis#helper("assert")

let s:completion_candidates = themis#suite("simple_align#options#CompletionCandidates")
function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_empty() abort
  let cmdline = "'<,'>SimpleAlign "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -lpadding 0 "
  let curpos  = strwidth(cmdline)
  let arglead = ""
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_all_option_names_if_arglead_is_single_hyphen() abort
  let cmdline = "'<,'>SimpleAlign -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-count", "-lpadding", "-rpadding", "-justify", "-c", "-l", "-r", "-j"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_matched_options_if_arglead_is_single_hyphens_and_a_char() abort
  for cmdline_prefix in ["'<,'>SimpleAlign ", "'<,'>SimpleAlign -count 1 "]
    let cmdline = cmdline_prefix .. "-c"
    let curpos  = strwidth(cmdline)
    let arglead = "-c"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-l"
    let curpos  = strwidth(cmdline)
    let arglead = "-l"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-r"
    let curpos  = strwidth(cmdline)
    let arglead = "-r"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-j"
    let curpos  = strwidth(cmdline)
    let arglead = "-j"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-a"
    let curpos  = strwidth(cmdline)
    let arglead = "-a"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "--"
    let curpos  = strwidth(cmdline)
    let arglead = "--"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
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
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   ["-count"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-lp"
    let curpos  = strwidth(cmdline)
    let arglead = "-lp"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   ["-lpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-rp"
    let curpos  = strwidth(cmdline)
    let arglead = "-rp"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   ["-rpadding"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-ju"
    let curpos  = strwidth(cmdline)
    let arglead = "-ju"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   ["-justify"],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "-ab"
    let curpos  = strwidth(cmdline)
    let arglead = "-ab"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
    \   [],
    \   "cmdline_prefix: " .. string(cmdline_prefix),
    \ )

    let cmdline = cmdline_prefix .. "--x"
    let curpos  = strwidth(cmdline)
    let arglead = "--x"
    call s:assert.equal(
    \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
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
      \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
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
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-1", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -lpadding "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -justify "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["left", "right"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_option_values_if_leading_argument_is_short_option() abort
  let arglead = ""

  let cmdline = "'<,'>SimpleAlign -c "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-1", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -c 1 -l "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  \ )

  let cmdline = "'<,'>SimpleAlign -c 1 -j "
  let curpos  = strwidth(cmdline)
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["left", "right"],
  \ )
endfunction

function s:completion_candidates.returns_list_of_matched_option_values_if_prev_leading_argument_is_option() abort
  let cmdline = "'<,'>SimpleAlign -count -"
  let curpos  = strwidth(cmdline)
  let arglead = "-"
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["-1"],
  \ )

  let cmdline = "'<,'>SimpleAlign -count 1 -justify l"
  let curpos  = strwidth(cmdline)
  let arglead = "l"
  call s:assert.equal(
  \   simple_align#options#CompletionCandidates(arglead, cmdline, curpos),
  \   ["left"],
  \ )
endfunction

let s:is_option = themis#suite("simple_align#options#IsOption")
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
    \   simple_align#options#IsOption(argument),
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
    \   simple_align#options#IsOption(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

let s:is_short_option_with_value = themis#suite("simple_align#options#IsShortOptionWithValue")
function s:is_short_option_with_value.returns_true_for_valid_short_option_with_value_argument() abort
  let arguments = [
  \   "-c1",
  \   "-c777",
  \   "-c-1",
  \   "-l2",
  \   "-l11",
  \   "-r0",
  \   "-r22",
  \   "-jleft",
  \   "-jright",
  \ ]

  for argument in arguments
    call s:assert.true(
    \   simple_align#options#IsShortOptionWithValue(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

function s:is_short_option_with_value.returns_false_for_only_valid_short_option_name_argument() abort
  let arguments = [
  \   "-c",
  \   "-l",
  \   "-r",
  \   "-j",
  \ ]

  for argument in arguments
    call s:assert.false(
    \   simple_align#options#IsShortOptionWithValue(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

function s:is_short_option_with_value.returns_false_for_valid_short_option_name_with_invalid_value_argument() abort
  let arguments = [
  \   "-c",
  \   "-cx",
  \   "-c-2",
  \   "-c.",
  \   "-l",
  \   "-lx",
  \   "-l-1",
  \   "-r",
  \   "-rx",
  \   "-r1.5",
  \   "-j",
  \   "-jx",
  \   "-j1",
  \ ]

  for argument in arguments
    call s:assert.false(
    \   simple_align#options#IsShortOptionWithValue(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

function s:is_short_option_with_value.returns_false_for_invalid_argument() abort
  let arguments = [
  \   "",
  \   "-",
  \   "-x",
  \   "1",
  \   "c",
  \   "l",
  \   "r",
  \   "j",
  \ ]

  for argument in arguments
    call s:assert.false(
    \   simple_align#options#IsShortOptionWithValue(argument),
    \   "argument: " .. argument,
    \ )
  endfor
endfunction

let s:is_valid_value = themis#suite("simple_align#options#IsValidValue")
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
    \   simple_align#options#IsValidValue(testcase.option_name, testcase.value),
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
    \   simple_align#options#IsValidValue(testcase.option_name, testcase.value),
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
      Throws /:E716:/ :call simple_align#options#IsValidValue(testcase.option_name, testcase.value)
    catch
      throw v:exception .. "\n\ntestcase: " .. string(testcase)
    endtry
  endfor
endfunction

let s:argument_to_name = themis#suite("simple_align#options#ArgumentToName")
function s:argument_to_name.converts_short_name_to_long_one() abort
  let testcases = [
  \   #{ argument: "-c", expected: "count" },
  \   #{ argument: "c",  expected: "count" },
  \   #{ argument: "c-", expected: "c-" },
  \   #{ argument: "a",  expected: "a" },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#ArgumentToName(testcase.argument),
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
    \   simple_align#options#ArgumentToName(testcase.argument),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

let s:extract_name_and_value = themis#suite("simple_align#options#ExtractNameAndValue")
function s:extract_name_and_value.extracts_option_name_and_value_from_valid_short_option_with_value() abort
  let testcases = [
  \   #{ given: "-c-1",    expected: #{ name: "count", value: "-1" } },
  \   #{ given: "-c1",     expected: #{ name: "count", value: "1" } },
  \   #{ given: "-c22",    expected: #{ name: "count", value: "22" } },
  \   #{ given: "-l0",     expected: #{ name: "lpadding", value: "0" } },
  \   #{ given: "-l2",     expected: #{ name: "lpadding", value: "2" } },
  \   #{ given: "-r0",     expected: #{ name: "rpadding", value: "0" } },
  \   #{ given: "-r3",     expected: #{ name: "rpadding", value: "3" } },
  \   #{ given: "-jleft",  expected: #{ name: "justify", value: "left" } },
  \   #{ given: "-jright", expected: #{ name: "justify", value: "right" } },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#ExtractNameAndValue(testcase.given),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:extract_name_and_value.does_not_throw_error_but_its_result_is_invalid_if_short_option_name_is_invalid() abort
  let testcases = [
  \   #{ given: "",      expected: #{ name: "", value: "" } },
  \   #{ given: "-",     expected: #{ name: "", value: "" } },
  \   #{ given: "-x",    expected: #{ name: "x", value: "" } },
  \   #{ given: "-x1",   expected: #{ name: "x", value: "1" } },
  \   #{ given: "-x777", expected: #{ name: "x", value: "777" } },
  \   #{ given: "c",     expected: #{ name: "", value: "" } },
  \   #{ given: "c1",    expected: #{ name: "1", value: "" } },
  \   #{ given: "c12",   expected: #{ name: "1", value: "2" } },
  \   #{ given: "l",     expected: #{ name: "", value: "" } },
  \   #{ given: "l1",    expected: #{ name: "1", value: "" } },
  \   #{ given: "l12",   expected: #{ name: "1", value: "2" } },
  \   #{ given: "r",     expected: #{ name: "", value: "" } },
  \   #{ given: "r1",    expected: #{ name: "1", value: "" } },
  \   #{ given: "r12",   expected: #{ name: "1", value: "2" } },
  \   #{ given: "j",     expected: #{ name: "", value: "" } },
  \   #{ given: "jleft", expected: #{ name: "lpadding", value: "eft" } },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#ExtractNameAndValue(testcase.given),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:extract_name_and_value.extracts_option_name_and_invalid_value_if_value_is_invalid() abort
  let testcases = [
  \   #{ given: "-c",    expected: #{ name: "count", value: "" } },
  \   #{ given: "-cx",   expected: #{ name: "count", value: "x" } },
  \   #{ given: "-c-2",  expected: #{ name: "count", value: "-2" } },
  \   #{ given: "-c.",   expected: #{ name: "count", value: "." } },
  \   #{ given: "-l",    expected: #{ name: "lpadding", value: "" } },
  \   #{ given: "-lx",   expected: #{ name: "lpadding", value: "x" } },
  \   #{ given: "-l-1",  expected: #{ name: "lpadding", value: "-1" } },
  \   #{ given: "-r",    expected: #{ name: "rpadding", value: "" } },
  \   #{ given: "-rx",   expected: #{ name: "rpadding", value: "x" } },
  \   #{ given: "-r1.5", expected: #{ name: "rpadding", value: "1.5" } },
  \   #{ given: "-j",    expected: #{ name: "justify", value: "" } },
  \   #{ given: "-jx",   expected: #{ name: "justify", value: "x" } },
  \   #{ given: "-j1",   expected: #{ name: "justify", value: "1" } },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#options#ExtractNameAndValue(testcase.given),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

let s:normalize_value = themis#suite("simple_align#options#NormalizeValue")
function s:normalize_value.normalizes_option_value() abort
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
    \   simple_align#options#NormalizeValue(testcase.option_name, testcase.value),
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
      Throws /:E716:/ :call simple_align#options#NormalizeValue(testcase.option_name, testcase.value)
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
    \   simple_align#options#NormalizeValue(testcase.option_name, testcase.value),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction
