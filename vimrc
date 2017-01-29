"  Some of this stuff was taken from the configs found at these links:
"  http://amix.dk/vim/vimrc.html
"  http://stackoverflow.com/questions/164847/what-is-in-your-vimrc
"  http://dougblack.io/words/a-good-vimrc.html
"  The plugin stuff mostly comes from the respective plugin pages.

set nocompatible              " be iMproved, required
filetype plugin indent on
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
syntax enable
" " Use Unix as the standard file type
set ffs=unix,dos,mac

" Print relative line numbers, useful for hjkl movements
set relativenumber
" set as fix to tmux background color problem
" (https://sunaku.github.io/vim-256color-bce.html)
set term=screen-256color

set autowrite

set backup
set writebackup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set cursorline 
au BufRead *.txt,*.md setlocal spell
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

function SetupDevEnvironment()
	if !empty(glob("./Makefile")) && !empty(glob(".ycm_extra_conf.py"))
		echom "It appears that your dev environment is already setup."
		return
	endif
	silent write
	silent !pymake 
	silent YcmGenerateConfig 
	silent YcmRestartServer
	redraw!
	echom "Developer environment created!"
endfunction

function Grip() 
	DoQuietly grip -b --quiet --wide % 
	autocmd VimLeavePre * call EndGrip()  " end grip when exiting
endfunction 

function EndGrip()
	silent ! kill $(ps aux | grep -v  grep | grep grip | awk '{print $2}')
	redraw!
endfunction 
	
let mapleader = "\<Space>"
nnoremap <Leader>pp :set paste<CR>
nnoremap	 <Leader>np :set nopaste<CR>
"" Space-w save file
"" Space-s enable spell checking on current buffer
nnoremap <Leader>sp :setlocal spell spelllang=en_ca<CR> 
nnoremap <Leader>w :w<CR>
"" Turn off spelling
nnoremap <Leader>nsp :set nospell<CR>
nnoremap <Leader>nh :noh <CR>
"fugitive git stuff
nnoremap <Leader>Gl :!git lg<CR>
nnoremap <Leader>Gc :Gcommit<CR>
nnoremap <Leader>Gdf :Gdiff<CR>
nnoremap <Leader>Gb :Gblame<CR>
nnoremap <Leader>Gs :Gstatus<CR>
"Tagbar class outline view
nnoremap <Leader>tt :TagbarToggle <CR>
" YCM
nnoremap <Leader>ydd :YcmShowDetailedDiagnostic<CR>
nnoremap <Leader>f :YcmCompleter FixIt <CR>
"	nnoremap <Leader>d :YcmCompleter GetDoc <CR>
"	nnoremap <Leader>t :YcmCompleter GetType <CR>
" Makefiles and dev environment 
nnoremap <Leader>mk :make<CR>
nnoremap <Leader>mr :make run<CR>
nnoremap <Leader>mc :make clean <CR>
nnoremap <Leader>pm :!pymake<CR>
nnoremap <Leader>sd :call SetupDevEnvironment() <CR>
" Golang stuff
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)
au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>gi <Plug>(go-info)
" Xcode stuff
au FileType swift nmap <Leader>xr :Xrun<CR>
au FileType swift nmap <Leader>xb :Xbuild<CR>
au FileType swift nmap <Leader>xt :Xtest<CR>
au FileType swift nmap <Leader>xo :Xopen<CR>
" Fun stuffs
nnoremap <Leader>sh :shell <CR>
nnoremap <Leader>gp :call Grip() <CR>
nnoremap <Leader>ngp :call EndGrip() <CR>
nnoremap <Leader>cb :bd <CR>

colorscheme monokai

" Buffers
map <Tab> :bnext<CR>
map <S-Tab> :bprevious<CR>
 
" Enable mouse support in console
set mouse=a

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'vim-scripts/Conque-GDB'
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
let g:ConqueGdb_Leader = 'g'
let g:ConqueGdb_Step = g:ConqueGdb_Leader . 'st'
let g:ConqueGdb_SrcSplit = 'left'
nnoremap <Leader>gdb :ConqueGdb a.out<CR>

Plugin 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_inactive_collapse=1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#format = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#max_lines = 20000
let g:airline#extensions#whitespace#show_message = 1
let g:airline#extensions#whitespace#trailing_format = 'trailing[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mixed-indent[%s]'

" Always show the status line
set laststatus=2
set number
set ruler
set showcmd

Plugin 'tpope/vim-fugitive'
Plugin 'christoomey/vim-tmux-navigator'

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

Plugin 'Valloric/YouCompleteMe'
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_error_symbol = '!!'
let g:ycm_warning_symbol = '>>'
let g:ycm_always_populate_location_list = 0
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 1
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
Plugin 'rdnetto/YCM-Generator' " For generating files required for YouCompleteMe
map <C-y> :YcmGenerateConfig <cr>
set wildmenu
set wildmode=list:longest,full

Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases 
set wildignore=*.o,*~,*.pyc,*.out
set magic " For regular expressions turn magic on
set showmatch " Show matching brackets when text indicator is over them

" Got backspace?
set backspace=2

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

Plugin 'fatih/vim-go'
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

Plugin 'scrooloose/nerdtree'
"autocmd vimenter * NERDTree "Starts it on vim launch
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif " Close NERDTree if its only window open
autocmd StdinReadPre * let s:std_in=1 " These two open NERDTree on start if no file specified on launch
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDTree on and off
map <C-n> :NERDTreeToggle <cr> 

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
