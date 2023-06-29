""" Filetype settings for cpp files

setlocal tabstop=4
setlocal shiftwidth=4

" indentation rules
" cindent should override autoindent, so this might be unnecessary as well
" might be unnecessary, because it is activated for C++ by default
"setlocal cindent
setlocal autoindent
setlocal smartindent
" to not indent after 'namespace' declaration
setlocal cino=N-s,g0,n0,+0

call SetTextWidth(80)

setlocal matchpairs+=<:>
