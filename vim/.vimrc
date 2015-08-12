set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"Plugin for using git inside vim
"Plugin 'tpope/vim-fugitive'

"Plugin for making YouComplete and UltiSnips compatible
Plugin 'ervandew/supertab'

"GitHub repo for easy commenting plugin
Plugin 'scrooloose/nerdcommenter'

"GitHub repo for Auto completion plugin
Plugin 'Valloric/YouCompleteMe'

"GitHub repo for automatically generating a file for semantic autocompletion plugin
"Plugin 'rdnetto/YCM-Generator'

"GitHub repo for working with filesystem plugin
Plugin 'scrooloose/nerdtree'

"Git repo for latex support
Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex' 

"plugin for a cool headerline
Plugin 'bling/vim-airline'

"plugin for using multiple cursors
"Plugin 'terryma/vim-multiple-cursors'

"plugin to automatic close braces and similar things
Plugin 'Raimondi/delimitMate'

"plugin for completing small code parts
Plugin 'SirVer/ultisnips'

"plugin for seeing difference with version control system file
Plugin 'vim-scripts/svndiff'

"Plugin for syntax checking inside vim
Plugin 'scrooloose/syntastic'

"Plugin to have the standard Ultisnips snippets
Plugin 'honza/vim-snippets'

"Plugin for vim support for julia
Plugin 'JuliaLang/julia-vim'

" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'

" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" If using a dark background within the editing area and syntax highlighting                                  
" turn on this option as well                                                                                 
"set background=dark                                                                                          
syntax on
hi Visual term=reverse cterm=reverse guibg=Grey

" Uncomment the following to have Vim jump to the last position when                                          
" reopening a file                                                                                            
if has("autocmd")                                                                                            
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif               
endif                                                                                                        

" The following are commented out as they cause vim to behave a lot                                           
" differently from regular Vi. They are highly recommended though.                                            
"set showcmd            " Show (partial) command in status line.                                              
"set showmatch          " Show matching brackets.                                                             
"set ignorecase         " Do case insensitive matching                                                        
"set smartcase          " Do smart case matching                                                              
"set incsearch          " Incremental search                                                                  
"set autowrite          " Automatically save before commands like :next and :make                             
"set hidden             " Hide buffers when they are abandoned                                                
"set mouse=a            " Enable mouse usage (all modes) 

"for moving cursor by lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

"for other right behavior for cursor movement
onoremap <silent> j gj
onoremap <silent> k gk

"Autoformat Indent
nnoremap <silent> F gg=G''

"replace with content of clipboard
"noremap <buffer> <silent> <M-r> "_d

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
	silent exe "normal! `[v`]\"_c"
	silent exe "normal! p"
endfunction

"define variable for end column
let myEndColumn=120
"set color for particular column
execute "set colorcolumn=".myEndColumn
highlight ColorColumn ctermbg=darkgray
"set end of columns to 110
execute "set tw=".myEndColumn

"to search for visually selected text
vnoremap // y/<C-R>"<CR>

"show relative line numbers and line number for current line
set relativenumber
set number

"delete to black hole
nnoremap <silent> <C-A> "_d

set exrc
set secure

"leaves preview scratch mode
autocmd CompleteDone * pclose

"set default .ycm_extra_conf.py
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

"so that vim-powerline appears all the time
set laststatus=2

"for support 256 colors
set t_Co=256

"""mappings for svndiff
"mapping for previous diff
noremap <F3> :call Svndiff("prev")<CR>
"mapping for next diff
noremap <F4> :call Svndiff("next")<CR>
"mapping to clear the diffs
noremap <F5> :call Svndiff("clear")<CR> 

"for autoupdate of difference to version control system 
let g:svndiff_autoupdate = 1 

"Disable arrow keys, force myself to use hjkl
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

"better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>""

"beginner settings for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"Disable error line length with pylin python checker
let g:syntastic_python_pylint_post_args="--max-line-length=120"

"toogle between syntastic enabled and disabled
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>

"find word under cursor and replace it something
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

"set shortcut to toggle display of nerdtree
map <C-e> :NERDTreeToggle<CR>

"display nerdtree, if vim is started without file argument
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
