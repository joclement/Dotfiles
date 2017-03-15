""" Filetype settings for cpp files

" indentation rules
" cindent should override autoindent, so this might be unnecessary as well
" might be unnecessary, because it is activated for C++ by default
"setlocal cindent
setlocal autoindent
setlocal smartindent
" to not indent after 'namespace' decleration
setlocal cino=N-s,g0,n0,+0
