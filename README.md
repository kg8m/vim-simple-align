[![Vim 8.2+](https://img.shields.io/badge/Vim-Support%208.2%2B-yellowgreen.svg?logo=vim)](https://github.com/vim/vim/tree/v8.2.0000)
[![Neovim nightly](https://img.shields.io/badge/Neovim-Support%20nightly-yellowgreen.svg?logo=neovim&logoColor=white)](https://github.com/neovim/neovim)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![test](https://github.com/kg8m/vim-simple-align/actions/workflows/test.yml/badge.svg)](https://github.com/kg8m/vim-simple-align/actions/workflows/test.yml)


vim-simple-align
==================================================

A Vim/Neovim plugin to align texts by simple way.

* vim-simple-align provides only 1 command and a few its options
  * no need to remember options because they can be completed
* delimiter used to split texts is always Vim's regular expression

vim-simple-align doesn't cover all alignment cases but aims to work nice in many common cases.

https://user-images.githubusercontent.com/694547/119252181-beec6380-bbe5-11eb-87ce-4ed643598962.mp4


Commands/Usage
--------------------------------------------------

vim-simple-align provides only 1 command: `:SimpleAlign`.

Usage:

```vim
:{RANGE}SimpleAlign {DELIMITER}
```

Or

```vim
:{RANGE}SimpleAlign {DELIMITER} {OPTIONS}
```

Delimiter is Vim's regular expression. Some characters may need to be escaped.

cf. `:h regular-expression`


### Options

#### `-count` (`-c`) option

`-count` option means how many times to split and align tokens. Available values are `-1` and integers greater than 0. `-1` means unlimited.

Default: `-1`


#### `-lpadding` (`-l`) option

`-lpadding` option means how many spaces to put left padding of each token. Available values are integers greater than or equal to 0.

Default: `1`


#### `-rpadding` (`-r`) option

`-rpadding` option means how many spaces to put right padding of each token. Available values are integers greater than or equal to 0.

Default: `1`


#### `-justify` (`-j`) option

`-justify` option means which side tokens should be on. Available values are `left` and `right`.

Default: `left`


Examples
--------------------------------------------------

### Align Markdown table

#### ❌ Not aligned

```md
a | bbb | ccccc
--- | --- | ---
012345 | 6 | 789
.. | .. | ..
```

```md
| a | bbb | ccccc |
| --- | --- | --- |
| 012345 | 6 | 789 |
| .. | .. | .. |
```


#### 🔧 Command

```vim
:1,4SimpleAlign |
```


#### ⭕️ Aligned

```md
a      | bbb | ccccc
---    | --- | ---
012345 | 6   | 789
..     | ..  | ..
```

```md
| a      | bbb | ccccc |
| ---    | --- | ---   |
| 012345 | 6   | 789   |
| ..     | ..  | ..    |
```


### Align Markdown table with justifying to right

#### ❌ Not aligned

```md
a | bbb | ccccc
--- | --- | ---
012345 | 6 | 789
.. | .. | ..
```

```md
| a | bbb | ccccc |
| --- | --- | --- |
| 012345 | 6 | 789 |
| .. | .. | .. |
```


#### 🔧 Command

```vim
:1,4SimpleAlign | -justify right
```


#### ⭕️ Aligned

```md
     a | bbb | ccccc
   --- | --- |   ---
012345 |   6 |   789
    .. |  .. |    ..
```

```md
|      a | bbb | ccccc |
|    --- | --- |   --- |
| 012345 |   6 |   789 |
|     .. |  .. |    .. |
```


### Align JSON, dictionary/hash items

#### ❌ Not aligned

JSON:

```json
{
  "a": "a",
  "bbb": "bbb",
  "ccccc": "ccccc"
}
```

JavaScript dictionary:

```js
{
  a: "a",
  bbb: "bbb",
  ccccc: "ccccc",
}
```

Ruby old Hash syntax:

```rb
{
  "a" => "a",
  "bbb" => "bbb",
  "ccccc" => "ccccc",
}
```


#### 🔧 Command

For JSON:

```vim
:2,4SimpleAlign [^:\ ]\+:
```

For JavaScript dictionary:

```vim
:2,4SimpleAlign \w\+:
```

For Ruby old Hash syntax:

```vim
:2,4SimpleAlign =>
```


#### ⭕️ Aligned

JSON:

```json
{
  "a":     "a",
  "bbb":   "bbb",
  "ccccc": "ccccc"
}
```

JavaScript dictionary:

```js
{
  a:     "a",
  bbb:   "bbb",
  ccccc: "ccccc",
}
```

Ruby old Hash syntax:

```rb
{
  "a"     => "a",
  "bbb"   => "bbb",
  "ccccc" => "ccccc",
}
```


### Align variable assignments

#### ❌ Not aligned

Basic case:

```js
const a = "a";
const bbb = "bbb";
const ccccc = "ccccc";
```

Case when multiple `=`s exist:

```js
const a = "a";
const bbb = "bbb";
const ccccc = "ccccc";
const d = (a === bbb)
```

`=` and `+=`:

```rb
a = "a"
a += "a"
```


#### 🔧 Command

For basic case:

```vim
:1,3SimpleAlign =
```

For the case when multiple `=`s exist:

```vim
:1,4SimpleAlign = -count 1
```

For `=` and `+=`:

```vim
:1,2SimpleAlign [+\ ]=
```


#### ⭕️ Aligned

Basic case:

```js
const a     = "a";
const bbb   = "bbb";
const ccccc = "ccccc";
```

Case when multiple `=`s exist:

```js
const a     = "a";
const bbb   = "bbb";
const ccccc = "ccccc";
const d     = (a === bbb)
```

`=` and `+=`:

```rb
a  = "a"
a += "a"
```


### Align output/result comments

#### ❌ Not aligned

JavaScript:

```js
a() //=> "a"
bbb() //=> "bbb"
ccccc() //=> "ccccc"
```

Ruby:

```rb
a #=> "a"
bbb #=> "bbb"
ccccc #=> "ccccc"
```


#### 🔧 Command

For JavaScript:

```vim
:1,3SimpleAlign //=> -lpadding 2
```

For Ruby:

```vim
:1,3SimpleAlign #=> -lpadding 2
```


#### ⭕️ Aligned

JavaScript:

```js
a()      //=> "a"
bbb()    //=> "bbb"
ccccc()  //=> "ccccc"
```

Ruby:

```rb
a      #=> "a"
bbb    #=> "bbb"
ccccc  #=> "ccccc"
```


### Align non-whitespace characters

#### ❌ Not aligned

```rb
t.belongs_to :user, null: false
t.string :name, null: false
t.boolean :active, null: false, default: true
t.boolean :foo, null: true, default: false
```


#### 🔧 Command

```vim
:1,4SimpleAlign \S\+ -lpadding 0
```


#### ⭕️ Aligned

```rb
t.belongs_to :user,   null: false
t.string     :name,   null: false
t.boolean    :active, null: false, default: true
t.boolean    :foo,    null: true,  default: false
```


Inspired by alignta
--------------------------------------------------

vim-simple-align is inspired by [h1mesuke/vim-alignta](<https://github.com/h1mesuke/vim-alignta>). It is a simple Vim plugin to align texts. It provides only 1 command `:Alignta` and has a few options and command syntaxes. It is a very great plugin but doesn't work on current Vim. vim-simple-align inherits its philosophy and focuses its limited essential features.


Why not vim-easy-align?
--------------------------------------------------

Yes, [vim-easy-align](https://github.com/junegunn/vim-easy-align) is a great Vim plugin. However, it is complicated and difficult for me. I can't remember its mappings, options, and syntaxes. It is a so cool product, but not for me.


Installation
--------------------------------------------------

If you use [dein.vim](https://github.com/Shougo/dein.vim):

```vim
call dein#add("kg8m/vim-simple-align")
```

Note: dein.vim's lazy loading feature with `on_cmd` option is not recommended for vim-simple-align. You will see `E471: Argument required: ...` if so. To tell the truth, lazy loading of vim-simple-align doesn't make Vim's startup faster. On the one hand, vim-simple-align just defines 1 command when added to `runtimepath`. On the other hand, dein.vim's lazy loading with `on_cmd` also defines a dummy command.


Vim9 script
--------------------------------------------------

You can use Vim9 script version if you use Vim 8.2.4053+. Vim9 script version is 5-10 times faster than legacy Vim script version. Vim9 script version is available on [`vim9` branch](https://github.com/kg8m/vim-simple-align/tree/vim9).

```vim
call dein#add("kg8m/vim-simple-align", { "rev": "vim9" })
```


Requirements
--------------------------------------------------

Vim 8.2+ or Neovim nightly
