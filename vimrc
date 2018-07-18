set nocompatible

" plugin manager {{{
call plug#begin('~/.vim/plugged')

" TODO make UltiSnips workable again
" TODO check if necessary
" For making YouComplete and UltiSnips compatible
Plug 'ervandew/supertab'

Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer'}
Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}

Plug 'altercation/vim-colors-solarized'

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'Raimondi/delimitMate'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'scrooloose/syntastic'

Plug 'JuliaEditorSupport/julia-vim'

Plug 'Vimjas/vim-python-pep8-indent'

Plug 'vim-scripts/a.vim', { 'for': 'cpp' }

Plug 'tpope/vim-surround'

Plug 'embear/vim-localvimrc'

Plug 'tpope/vim-dispatch'

Plug 'sjl/gundo.vim'

Plug 'vim-latex/vim-latex'

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

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" compatability YCM, UltiSnips {{{
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" }}}

" UltiSnips key {{{
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>""
" }}}

" syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
"disable syntastic by default
let g:syntastic_check_on_open = 0

let g:syntastic_python_pylint_post_args="--max-line-length=120"

nnoremap <C-k> :SyntasticCheck<CR> :SyntasticToggleMode<CR>
" }}}

" nerdtree settings {{{
map <C-e> :NERDTreeMirrorToggle<CR>
"display nerdtree, if vim is started without file argument
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

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

" update makeprg {{{
function! UpdateMakeSettings()
    set makeprg=make\ -C\ $MY_BUILD_DIR
endfunction
call UpdateMakeSettings()
nnoremap <silent> <F7> :call UpdateMakeSettings()<CR>
" }}}

" }}}

let g:localvimrc_persistent = 1

let g:gundo_prefer_python3 = 1

" }}}


" colorscheme {{{
try
    set t_Co=256
    set background=dark
    let g:solarized_termcolors=&t_Co
    let g:solarized_termtrans=1
    colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
endtry
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
" }}}

" search, replace {{{
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"to search for visually selected text
vnoremap // y/<C-R>"<CR>

"find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

set grepprg=grep\ -n\ $*\ /dev/null\ --exclude-dir={.hg,.git}\ -I
" }}}


" spelling {{{
highlight SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black

let g:myLang=0
let g:myLangList=["nospell","de_de","en_us", "en_gb"]
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


" trailing whitespace {{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * call clearmatches()
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" remove trailing whitespace
function! RemoveTrailingWhitespace()
    if (exists('b:NoRemoveTrailingWhitespace') || &ft=='' || &diff=='diff')
        return
    endif
    %s/\s\+$//ge
endfun
autocmd BufWritePre * call RemoveTrailingWhitespace()
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
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
            \,*.jpg,*.png,*.xpm,*.gif,*.h5,*.pdf,*.aux,*.ods,*.bbl
                        \,*.toc,*.pyc

set backspace=2

set history=1000
" }}}

set wildmenu

" vim:foldmethod=marker foldlevel=0
