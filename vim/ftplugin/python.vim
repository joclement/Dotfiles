call SetTextWidth(88)

let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_template = 1

if executable('black')
  set formatprg=black\ -q\ 2>/dev/null\ --stdin-filename\ %\ -
endif

let b:ale_fixers = ['autoimport']
