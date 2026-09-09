let g:ale_perl_perl_options = '-c -Mwarnings -Ilib -It/lib'

let b:ale_linters = ['perlcritic', 'perlnavigator']

let g:ale_perl_perlcritic_showrules = 1
let g:ale_type_map = {
\    'perlcritic': {'ES': 'WS', 'E': 'W'},
\}

set tabstop=2
set shiftwidth=2
