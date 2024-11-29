call SetTextWidth(88)

let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_template = 1

if executable('black')
  set formatprg=black\ -q\ 2>/dev/null\ --stdin-filename\ %\ -
endif

let b:ale_fixers = ['autoimport']

let g:ale_python_flake8_options = '--ignore=E501,W503'

let g:ale_python_auto_virtualenv = 1
