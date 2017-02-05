""" Filetype settings for cpp files

" indentation rules
set backspace=2
" cindent should override autoindent, so this might be unnecessary as well
" might be unnecessary, because it is activated for C++ by default
"set cindent
set autoindent
set smartindent
" to not indent after 'namespace' decleration
set cino=N-s,g0,n0,+0
