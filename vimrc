set nocompatible

" plugin manager {{{
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim',
    \ {'branch': 'release',
    \  'commit': 'bbaa1d5d1ff3cbd9d26bb37cfda1a990494c4043'}

Plug 'altercation/vim-colors-solarized'

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'Raimondi/delimitMate'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'scrooloose/syntastic'

Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-python/python-syntax'

Plug 'vim-scripts/a.vim', { 'for': 'cpp' }

Plug 'tpope/vim-surround'

Plug 'tpope/vim-abolish'

Plug 'embear/vim-localvimrc'

Plug 'tpope/vim-dispatch', { 'tag': 'v1.5' }

Plug 'sjl/gundo.vim'

Plug 'vim-latex/vim-latex'

Plug 'Matt-Deacalion/vim-systemd-syntax'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'cespare/vim-toml'

Plug 'editorconfig/editorconfig-vim'

Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'

call plug#end()
" }}}


" plugin settings {{{

runtime macros/matchit.vim

" powerline {{{
let python3_works=1
try
    python3 from powerline.vim import setup as powerline_setup
    python3 powerline_setup()
    python3 del powerline_setup
catch /E319:/
    let python3_works=0
endtry
if python3_works == 0
    try
        python from powerline.vim import setup as powerline_setup
        python powerline_setup()
        python del powerline_setup
    catch /E319:/
    endtry
endif
" so that vim-powerline appears all the time
set laststatus=2
" }}}

" UltiSnips key {{{
let g:UltiSnipsExpandTrigger = "<c-j>"
" }}}

" syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

let g:syntastic_python_checkers = ['flake8']

nnoremap <C-k> :SyntasticCheck<CR> :SyntasticToggleMode<CR>

" latex {{{
filetype plugin on
filetype indent on
" }}}

" }}}

" nerdtree settings {{{
map <C-e> :NERDTreeMirrorToggle<CR>

let NERDTreeIgnore = ['\.pyc$']
" }}}

" Dispatch {{{
" function show Dispatch quickfix {{{
function! DispatchCw()
    execute 'Copen'
    execute 'cw'
endfunction
command! Cw call DispatchCw()
" }}}
" }}}

" coc {{{
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-docker',
  \ 'coc-emoji',
  \ 'coc-git',
  \ 'coc-import-cost',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-lua',
  \ 'coc-marketplace',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-snippets',
  \ 'coc-stylelint',
  \ 'coc-tsserver',
  \ 'coc-ultisnips',
  \ 'coc-yaml'
  \ ]
" }}}

let g:localvimrc_persistent = 1

let g:gundo_prefer_python3 = 1

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
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"to search for visually selected text
vnoremap // y/<C-R>"<CR>

"find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
else
    set grepprg=grep\ -n\ $*\ /dev/null\
                \ --exclude-dir={.git,build,.mypy_cache,.nox,.pytest_cache}\
                \ --exclude=tags\ -I
endif
" }}}


" spelling {{{
highlight SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black

let g:myLang=0
let g:myLangList=["nospell","de_de","en_us", "en_gb", "nl"]
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

" Highlight tabs {{{
highlight Tabs ctermbg=red guibg=red
2match Tabs /\t/
autocmd BufWinEnter * 2match Tabs /\t/
autocmd InsertEnter * call clearmatches()
autocmd InsertLeave * 2match Tabs /\t/
autocmd BufWinLeave * call clearmatches()
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
    if (exists('b:NoRemoveTrailingWhitespace') || &ft=='' || &diff)
        return
    endif
    %s/\s\+$//ge
endfun
autocmd BufWritePre * call RemoveTrailingWhitespace()
" }}}

" remove empty lines at EOF {{{
function TrimEndLines()
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

function IsAnyParentDir(dirname)
    let path = fnamemodify(bufname('%'), ':p:h')
    let dirs = split(path, '/')

    for dir in dirs
        if dir == a:dirname
            return 1
        endif
    endfor

    return 0
endfunction
" }}}


" vim:foldmethod=marker foldlevel=0
