set nocompatible

" plugin manager {{{
call plug#begin('~/.vim/plugged')

" TODO make UltiSnips workable again
" TODO check if necessary
" For making YouComplete and UltiSnips compatible
Plug 'ervandew/supertab'

Plug 'Valloric/YouCompleteMe', {'do': './install.py'}
" TODO get it to work
"Plug 'rdnetto/YCM-Generator'

Plug 'altercation/vim-colors-solarized'

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'Raimondi/delimitMate'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'scrooloose/syntastic'

Plug 'JuliaEditorSupport/julia-vim'

Plug 'vim-scripts/a.vim', { 'for': 'cpp' }

Plug 'tpope/vim-surround'

Plug 'embear/vim-localvimrc'

Plug 'tpope/vim-dispatch'

" TODO add plugin for latex, especially for latex indentation

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

" }}}


" colorscheme {{{
set t_Co=256
set background=dark
let g:solarized_termcolors=&t_Co
let g:solarized_termtrans=1
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
let myEndColumn=80
execute "set tw=".myEndColumn
let myColorColumn=myEndColumn+1
execute "set colorcolumn=".myColorColumn
highlight ColorColumn ctermbg=black
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


" search, replace {{{
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"to search for visually selected text
vnoremap // y/<C-R>"<CR>

"find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" function cp{motion} {{{
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
	silent exe "normal! `[v`]\"_c"
	silent exe "normal! p"
endfunction
" }}}

" }}}


" spelling {{{
highlight SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black

let b:myLang=0
let g:myLangList=["nospell","de_de","en_us"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
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
    if (exists('b:NoRemoveTrailingWhitespace') || &ft=='')
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
set foldlevel=20
set foldcolumn=0
" }}}


" misc {{{
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
			\,*.jpg,*.png,*.xpm,*.gif,*.h5,*.pdf,*.aux,*.ods,*.bbl
                        \,*.toc

set backspace=2

set history=1000
" }}}


"shortcut to go into braces while editing
" TODO what is this good for?
imap <C-c> <CR><Esc>O

" TODO not sure if it works
" to have autocompletion for selecting new files from current working directory
" for each buffer in vim, so hopefull each tab as well
let g:netrw_keepdir=0
" to have the same effect with the explorer, so hopefully nerdtree as well
set browsedir=current

" use tags of any upper dir, if they are not available in the current dir
" TODO remove?
set tags+=./tags;

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
" TODO what is this option good for?
hi Visual term=reverse cterm=reverse guibg=Grey

" vim:foldmethod=marker foldlevel=0
