set nocompatible              " be iMproved, required

call plug#begin('~/.vim/plugged')

" TODO make UltiSnips workable again
" TODO check if necessary
" For making YouComplete and UltiSnips compatible
Plug 'ervandew/supertab'

" For easy commenting
Plug 'scrooloose/nerdcommenter'

" Auto completion
Plug 'Valloric/YouCompleteMe', {'do': './install.py'}

" Solarized color theme
Plug 'altercation/vim-colors-solarized'

" TODO get it to work
" For automatically generating a file for semantic autocompletion plugin
"Plug 'rdnetto/YCM-Generator'

" filesystem explorer
Plug 'scrooloose/nerdtree'

" To automatic close braces and similar things
Plug 'Raimondi/delimitMate'

" For completing small code parts
Plug 'SirVer/ultisnips'

" For syntax checking inside vim
Plug 'scrooloose/syntastic'

" To have the standard Ultisnips snippets
Plug 'honza/vim-snippets'

" for julia coding
Plug 'JuliaEditorSupport/julia-vim'

" For easy switch between source and header file(C++)
Plug 'vim-scripts/a.vim', { 'for': 'cpp' }

" To edit elements, which surround current position
Plug 'tpope/vim-surround'

Plug 'embear/vim-localvimrc'

Plug 'tpope/vim-dispatch'

Plug 'jistr/vim-nerdtree-tabs'

" TODO add plugin for latex, especially for latex indentation

call plug#end()


" to support 256 colors
set t_Co=256
set background=dark
if !has('gui_running')
        let g:solarized_termcolors=&t_Co
	let g:solarized_termtrans=1
endif
colorscheme solarized

" setup powerline for vim
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

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
hi Visual term=reverse cterm=reverse guibg=Grey

" Uncomment the following to have Vim jump to the last position when
" reopening a file
function! JumpToLastPosOpen()
    if exists("b:NoJumpToLastPosOpen")
        return
    endif
    if line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g'\""
    endif
endfunction
autocmd BufReadPost * call JumpToLastPosOpen()


set hidden


"for moving cursor by lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

"for other right behavior for cursor movement
onoremap <silent> j gj
onoremap <silent> k gk

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
	silent exe "normal! `[v`]\"_c"
	silent exe "normal! p"
endfunction

"define variable for end column
if !has('gui_running')
	let myEndColumn=80
	let myColorColumn=myEndColumn+1
	"set color for particular column
	execute "set colorcolumn=".myColorColumn
	highlight ColorColumn ctermbg=black
	"set end of columns to 80
	execute "set tw=".myEndColumn
endif

"""presentation settings
"to search for visually selected text
vnoremap // y/<C-R>"<CR>
"show relative line numbers and line number for current line
set relativenumber
set number

"Disable error line length with pylin python checker
let g:syntastic_python_pylint_post_args="--max-line-length=120"

"find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

""""""""""""SETTINGS FOR PLUGINS""""""""""""""""""""""""""""""

"set default .ycm_extra_conf.py
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

"toogle between syntastic enabled and disabled, using keys CTRL+k
nnoremap <C-k> :SyntasticCheck<CR> :SyntasticToggleMode<CR>

"make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

"better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>""

""beginner settings for syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
"disable syntastic by default
let g:syntastic_check_on_open = 0

"""settings for nerdtree
"set shortcut to toggle display of nerdtree
map <C-e> :NERDTreeMirrorToggle<CR>
"display nerdtree, if vim is started without file argument
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"""General indentation rules
set expandtab
set tabstop=4
set shiftwidth=4
set shiftround

"activate matchit plugin, is included in normal vim distribution
"the plugin is for matching, f.x. if or function blocks with %
runtime macros/matchit.vim

"""search settings
"highlight search matches
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" ignore these files when completing names and in explorer
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
			\,*.jpg,*.png,*.xpm,*.gif,*.h5,*.pdf,*.aux,*.ods,*.bbl
                        \,*.toc


"""behavior settings

"activate backspace
set backspace=2

set history=1000

"automatically read file that has been changed on disk and doesn't have changes in vim
set autoread

""spell settings
" highlight spell errors
hi SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black
"" toggle spell check with <F8>, cycle through all languages
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

" function to toggle linenumber showing
function! ToggleLineNumber()
    set relativenumber!
    set number!
endfunction
nnoremap <silent> <F6> :call ToggleLineNumber()<CR>

"shortcut to go into braces while editing
imap <C-c> <CR><Esc>O

" specific gvim settings
if has('gui_running')
	set lines=30 columns=100
endif

" TODO not sure if it works
" to have autocompletion for selecting new files from current working directory
" for each buffer in vim, so hopefull each tab as well
let g:netrw_keepdir=0
" to have the same effect with the explorer, so hopefully nerdtree as well
set browsedir=current

" use tags of any upper dir, if they are not available in the current dir
set tags+=./tags;


" set makeprg to use make inside vim
function! UpdateMakeSettings()
    set makeprg=make\ -C\ $MY_BUILD_DIR
endfunction
call UpdateMakeSettings()
nnoremap <silent> <F7> :call UpdateMakeSettings()<CR>

" highlight trailing whitespace
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

" command for dispatch like normal cw command
function! DispatchCw()
    execute 'Copen'
    execute 'cw'
endfunction
command! Cw call DispatchCw()

function! AutoCloseQuickfix()
    if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"
        q
    endif
endfunction

augroup QFClose
    autocmd!
    autocmd WinEnter * call AutoCloseQuickfix()
augroup END
