let s:assert = themis#helper("assert")

let s:MARKDOWN_TABLE =<< MARKDOWN
aaa | b | ccccc
--- | --- | ---
d | ee | fff
あ | い | う
MARKDOWN

let s:JS =<< JS
function foo() {
  const a = 1;
  const bbb = 22;
  const ccccc = 333;

  return {
    A: a,
    BBB: bbb,
    CCCCC: ccccc,
  };
}
JS

let s:VIM_SCRIPT =<< VIM
function Foo() abort
  let a = 1
  let a += 2
  let a += 3

  let b = "1"
  let b ..= "2"
  let b ..= "3"

  return [a, bbb, ccccc]
endfunction
VIM

let s:JSON =<< JSON
{
  "A": "a",
  "BBB": "bbb",
  "CCCCC": "ccccc",
}
JSON

let s:RUBY =<< RUBY
p :foo, a: "a", bbb: "bbb", ccccc: "ccccc"
p :foobar, "a": "aaa", "bbb": "bbb", "ccccc": "ccccc"

p :foo, :a => "a", :bbb => "bbb", :ccccc => "ccccc"
p :foobar, :"a" => "aaa", :"bbb" => "bbb", :"ccccc" => "ccccc"
RUBY

let s:command = themis#suite(":SimpleAlign")
function s:command.aligns_markdown_table() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign |", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_minus_1_count_option_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -count -1", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_1_count_option_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa | b | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee | fff",
  \   "あ  | い | う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -count 1", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_1_padding_options_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -lpadding 1 -rpadding 1", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_0_padding_options_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa|b  |ccccc",
  \   "---|---|---",
  \   "d  |ee |fff",
  \   "あ |い |う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -lpadding 0 -rpadding 0", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_other_padding_options_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa   |  b     |  ccccc",
  \   "---   |  ---   |  ---",
  \   "d     |  ee    |  fff",
  \   "あ    |  い    |  う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -lpadding 3 -rpadding 2", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_markdown_table_if_right_justify_option_given() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  let formatted_lines = [
  \   "aaa |   b | ccccc",
  \   "--- | --- |   ---",
  \   "  d |  ee |   fff",
  \   " あ |  い |    う",
  \ ]

  call setline(1, s:MARKDOWN_TABLE)

  execute printf("%d,%dSimpleAlign | -justify right", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_already_aligned_markdown_table() abort
  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \ ]

  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  call setline(1, formatted_lines)

  execute printf("%d,%dSimpleAlign |", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_already_aligned_markdown_table_if_first_tokens_are_empty() abort
  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "    | ee  | fff",
  \   "    | い  | う",
  \ ]

  let firstlnum = 1
  let lastlnum  = firstlnum + 3

  call setline(1, formatted_lines)

  execute printf("%d,%dSimpleAlign |", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_variable_assignments() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "  const a     = 1;",
  \   "  const bbb   = 22;",
  \   "  const ccccc = 333;",
  \ ]

  call setline(1, s:JS)

  execute printf("%d,%dSimpleAlign =", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_variable_assignments_if_right_justify_option_given() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "      const a =   1;",
  \   "    const bbb =  22;",
  \   "  const ccccc = 333;",
  \ ]

  call setline(1, s:JS)

  execute printf("%d,%dSimpleAlign = -justify right", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_variable_assignments_with_non_whitespace_char() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "  const a     = 1;",
  \   "  const bbb   = 22;",
  \   "  const ccccc = 333;",
  \ ]

  call setline(1, s:JS)

  execute printf("%d,%dSimpleAlign =", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_variable_assignments_with_non_whitespace_char_and_justifying_to_right() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "  const     a =   1;",
  \   "  const   bbb =  22;",
  \   "  const ccccc = 333;",
  \ ]

  call setline(1, s:JS)

  execute printf("%d,%dSimpleAlign \\S\\+ -lpadding 0 -justify right", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_variable_assignments_and_value_appendings() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "  let a  = 1",
  \   "  let a += 2",
  \   "  let a += 3",
  \ ]

  call setline(1, s:VIM_SCRIPT)

  execute printf("%d,%dSimpleAlign [\\ +]=", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_dictionary_items() abort
  let firstlnum = 7
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   "    A:     a,",
  \   "    BBB:   bbb,",
  \   "    CCCCC: ccccc,",
  \ ]

  call setline(1, s:JS)

  execute printf("%d,%dSimpleAlign \\w\\+:", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_json_items() abort
  let firstlnum = 2
  let lastlnum  = firstlnum + 2

  let formatted_lines = [
  \   '  "A":     "a",',
  \   '  "BBB":   "bbb",',
  \   '  "CCCCC": "ccccc",',
  \ ]

  call setline(1, s:JSON)

  execute printf("%d,%dSimpleAlign [^:\\ ]\\+:", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:command.aligns_with_non_whitespace_chars() abort
  let firstlnum = 1
  let lastlnum  = firstlnum + 1

  let formatted_lines = [
  \   'p :foo,    a:   "a",   bbb:   "bbb", ccccc:   "ccccc"',
  \   'p :foobar, "a": "aaa", "bbb": "bbb", "ccccc": "ccccc"',
  \ ]

  call setline(1, s:RUBY)

  execute printf("%d,%dSimpleAlign \\S\\+ -lpadding 0", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)

  let firstlnum = 4
  let lastlnum  = firstlnum + 1

  let formatted_lines = [
  \   'p :foo,    :a   => "a",   :bbb   => "bbb", :ccccc   => "ccccc"',
  \   'p :foobar, :"a" => "aaa", :"bbb" => "bbb", :"ccccc" => "ccccc"',
  \ ]

  call setline(1, s:RUBY)

  execute printf("%d,%dSimpleAlign \\S\\+ -lpadding 0", firstlnum, lastlnum)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction
