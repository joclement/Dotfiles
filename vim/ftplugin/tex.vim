setlocal tabstop=2
setlocal shiftwidth=2

set textwidth=0
set wrapmargin=0

let g:tex_flavor='latex'
" to not check spelling in comments
let g:tex_comment_nospell=1

set makeprg='make'

" cycle only through wanted refs, e.g. after typing 'fig:'
set iskeyword+=:

let g:syntastic_tex_checkers = ['chktex']
