set nocompatible

" basic settings {{{
syntax enable
filetype plugin indent on
" }}}

" plugin settings {{{

" fzf {{{
set runtimepath+=~/.fzf
" }}}

" vim-airline {{{
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
" }}}

" file explorer {{{

" built-in {{{
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_fastbrowse = 2
" }}}

" NerdTree {{{
map <C-e> :NERDTreeMirrorToggle<CR>
let NERDTreeRespectWildIgnore=1
" }}}

" }}}

" Dispatch {{{
function! DispatchCw()
    execute 'Copen'
    execute 'cw'
endfunction
command! Cw call DispatchCw()
" }}}

" CoC {{{
" Based on https://github.com/neoclide/coc.nvim#example-vim-configuration
set encoding=utf-8

set nobackup
set nowritebackup

set updatetime=300

set signcolumn=yes

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-docker',
  \ 'coc-emoji',
  \ 'coc-go',
  \ 'coc-git',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-lua',
  \ 'coc-perl',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-snippets',
  \ 'coc-stylelint',
  \ 'coc-ultisnips',
  \ 'coc-vimlsp',
  \ 'coc-yaml'
  \ ]

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" }}}

" lvimrc {{{
let g:localvimrc_persistent = 1
" }}}

" gundo {{{
let g:gundo_prefer_python3 = 1
" }}}

" vim-latex {{{
let g:tex_flavor='latex'
" }}}

" codeium {{{
let g:codeium_filetypes_disabled_by_default = v:true

let g:codeium_filetypes = {
    \ "bash": v:true,
    \ "Dockerfile": v:true,
    \ "go": v:true,
    \ "perl": v:true,
    \ "python": v:true,
    \ }
" }}}

" }}}

" colorscheme {{{
set background=dark
colorscheme solarized
" }}}

" row numbers {{{
set relativenumber
set number

" line number toggle {{{
function! ToggleLineNumber()
    set relativenumber!
    set number!
endfunction
nnoremap <silent> <F6> :call ToggleLineNumber()<CR>
" }}}

" }}}

" end column highlighting {{{
function! SetTextWidth(myTextwidth)
    let myEndColumn = a:myTextwidth
    execute "set textwidth=".myEndColumn
    set colorcolumn=+1
    highlight ColorColumn ctermbg=black
endfunction

call SetTextWidth(80)
" }}}

" function jump to last pos open {{{
function! JumpToLastPosOpen()
    if exists("b:NoJumpToLastPosOpen")
        return
    endif
    if line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g'\""
    endif
endfunction
autocmd BufReadPost * call JumpToLastPosOpen()
" }}}

" cursor movement by line {{{
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

onoremap <silent> j gj
onoremap <silent> k gk
" }}}

" indentation {{{
set expandtab
set tabstop=4
set shiftwidth=4
set shiftround
" }}}

" syntax highlighting {{{
let g:load_doxygen_syntax=1
let g:doxygen_javadoc_autobrief=0
let g:python_highlight_all = 1
" }}}

" search, replace {{{
set ignorecase
set smartcase

set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" to search for visually selected text
vnoremap // y/<C-R>"<CR>

" find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

if executable('ag')
    set grepprg=ag\ --hidden\ --vimgrep\
                \ --ignore-dir=.git\
                \ --ignore-dir=build\
                \ --ignore-dir=.mypy_cache\
                \ --ignore-dir=.nox\
                \ --ignore-dir=.pytest_cache\
                \ --ignore-dir=.tox\
                \ --ignore=tags
else
    set grepprg=grep\ -n\ $*\ /dev/null\
                \ --exclude-dir={.git,build,.mypy_cache,.nox,.pytest_cache}\
                \ --exclude=tags\ -I
endif
" }}}

" spelling {{{
highlight SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black

let g:myLang=0
let g:myLangList=["nospell", "de_de", "en_us", "en_gb", "nl"]
function! ToggleSpell()
  let g:myLang += 1
  if g:myLang>=len(g:myLangList) | let g:myLang=0 | endif
  if g:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, g:myLang)
  endif
  echo "spell checking language:" g:myLangList[g:myLang]
endfunction

nmap <silent> <F8> :call ToggleSpell()<CR>
" }}}

" Highlight spacing characters and too long lines {{{
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
" }}}

" trailing whitespace {{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * call clearmatches()
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" remove trailing whitespace
function! RemoveTrailingWhitespace()
    if (exists('b:NoRemoveTrailingWhitespace') || &diff || &binary)
        return
    endif
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * call RemoveTrailingWhitespace()
" }}}

" remove empty lines at EOF {{{
function! TrimEndLines()
    if (exists('b:NoTrimEndLines') || &ft=='' || &diff)
        return
    endif
    let save_cursor = getpos(".")
    silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', save_cursor)
endfunction

autocmd BufWritePre * call TrimEndLines()
" }}}

" buffer management {{{
set autoread

set hidden

function! DeleteHiddenUnmodifiedBuffers()
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')),
            \ 'bufexists(v:val) && index(tpbl, v:val)==-1')
        if getbufvar(buf, '&mod') == 0
            silent execute 'bwipeout' buf
            let closed += 1
        endif
    endfor
    echo "Closed ".closed." hidden buffers"
endfunction
" }}}

" auto close quickfix {{{
function! AutoCloseQuickfix()
    if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"
        q
    endif
endfunction

augroup QFClose
    autocmd!
    autocmd WinEnter * call AutoCloseQuickfix()
augroup END
" }}}

" folding {{{
set foldmethod=syntax
set foldlevel=3
set foldnestmax=5
" }}}

" misc {{{
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
               \,*.jpg,*.png,*.xpm,*.gif,*.h5,*.pdf,*.aux,*.ods,*.bbl
               \,*.toc,*.pyc

set backspace=2

set history=10000

set wildmenu

set scrolloff=3

function! IsAnyParentDir(dirname)
    let path = fnamemodify(bufname('%'), ':p:h')
    let dirs = split(path, '/')

    for dir in dirs
        if dir == a:dirname
            return 1
        endif
    endfor

    return 0
endfunction

" Adapted from https://vi.stackexchange.com/questions/29062
function! StartsWith(str, start)
    return a:str[0:len(a:start)-1] ==# a:start
endfunction

function! UpdateMakeSettings()
    set makeprg=nice\ -n\ 19\ make\ -j\ $MAKE_PARALLELIZATION\ -C\ $MY_BUILD_DIR
endfunction

autocmd BufRead requirements-dev.txt setlocal filetype=requirements

" }}}

" vim:foldmethod=marker foldlevel=0
