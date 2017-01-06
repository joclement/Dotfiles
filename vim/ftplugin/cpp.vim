""" Filetype settings for cpp files

" set indentation level for cpp files
" not really necessary anymore because of general rules, so commenting it
"let tabsize = 4
"set expandtab
"execute "set shiftwidth=".tabsize
"execute "set softtabstop=".tabsize

" indentation rules
set backspace=2
" cindent should override autoindent, so this might be unnecessary as well
" might be unnecessary, because it is activated for C++ by default
"set cindent
set autoindent
set smartindent
" to not indent after 'namespace' decleration
set cino=N-s,g0,n0,+0
