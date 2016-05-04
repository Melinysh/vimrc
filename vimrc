"  Some of this stuff was taken from the configs found at these links:
"  http://amix.dk/vim/vimrc.html
"  http://stackoverflow.com/questions/164847/what-is-in-your-vimrc
"  http://dougblack.io/words/a-good-vimrc.html
"  The plugin stuff mostly comes fromt the respective plugin pages.

" Required {{{
set nocompatible              " be iMproved, required
filetype on                  " required
filetype plugin on
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" " Use Unix as the standard file type
set ffs=unix,dos,mac

"autocmd! " Remove ALL autocommands for the current group. (Prevents double loading)

" }}}
" Backup {{{
set backup
set writebackup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
"}}}
" Experimental {{{
set cursorline " Experimental underline current working line
au BufRead *.txt,*.md setlocal spell
"set lazyredraw " E
"}}}
"{{{ Functions 
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
"}}}
" Leader and Mappings {{{
	let mapleader = "\<Space>"
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
	nnoremap <Leader>mk :!Make<CR>
	nnoremap <Leader>mr :!Make && ./a.out<CR>
	nnoremap <Leader>mc :!Make clean <CR>
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
	" Fun stuffs
	nnoremap <Leader>sh :shell <CR>
	nnoremap <Leader>gp :call Grip() <CR>
	nnoremap <Leader>ngp :call EndGrip() <CR>
	nnoremap <Leader>cb :bd <CR>
" }}}
" Color Scheme {{{
let g:molokai_original = 1
let g:rehash256 = 1
set t_Co=256
autocmd VimEnter * colorscheme molokai " set it manually, doesn't seem to automatically
"}}}
" Markers {{{
set foldenable          " enable folding
set foldmethod=marker
set foldlevel=0
set modelines=1
"}}}
 " Movement {{{
" Buffers
map <Tab> :bnext<CR>
map <S-Tab> :bprevious<CR>

" Enable mouse support in console
set mouse=a
"}}}
"Vundle {{{
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"}}}
" Debugging {{{
Plugin 'vim-scripts/Conque-GDB'
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
let g:ConqueGdb_Leader = 'g'
let g:ConqueGdb_Step = g:ConqueGdb_Leader . 'st'
let g:ConqueGdb_SrcSplit = 'left'
nnoremap <Leader>gdb :ConqueGdb a.out<CR>

Plugin 'rizzatti/dash.vim'
nmap <silent> <Leader>l <Plug>DashSearch
" }}}
" Status Bar {{{
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
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#ctrlp#show_adjacent_modes = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#max_lines = 20000
let g:airline#extensions#whitespace#show_message = 1
let g:airline#extensions#whitespace#trailing_format = 'trailing[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mixed-indent[%s]'
let g:airline#extensions#ctrlspace#enabled = 1
set ttimeoutlen=50 " fix pause after leaving insert mode

" Always show the status line
set laststatus=2
set number
set ruler
set showcmd
"}}}
"{{{ Source Control
Plugin 'tpope/vim-fugitive'
"}}}
"{{{ Visuals/Windows/Viewers
Plugin 'majutsushi/tagbar'

Plugin 'joonty/vim-do.git'

"}}}
" Search {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set runtimepath^=~/.vim/bundle/ctrlp.vim
" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
"}}}
" Autocomplete {{{
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
"Plugin 'ervandew/supertab'
Plugin 'rdnetto/YCM-Generator' " For generating files required for YouCompleteMe
map <C-y> :YcmGenerateConfig <cr>
set wildmenu
set wildmode=list:longest,full
"}}}
" Syntax {{{
Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
syntax on " enables syntax highlighting
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

" Use english for spellchecking, but don't spellcheck by default
 if version >= 700
	set spl=en spell
	set nospell
  endif
set autoindent
"}}}
" Golang {{{
Plugin 'fatih/vim-go'

let g:go_fmt_command = "goimports"
Plugin 'garyburd/go-explorer'

" }}}
" Directory {{{
Plugin 'scrooloose/nerdtree'
"autocmd vimenter * NERDTree "Starts it on vim launch
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif " Close NERDTree if its only window open
autocmd StdinReadPre * let s:std_in=1 " These two open NERDTree on start if no file specified on launch
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDTree on and off
map <C-n> :NERDTreeToggle <cr> 
"}}}
" Wrap Up {{{
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
"}}}

" vim:foldmethod=marker:foldlevel=0
