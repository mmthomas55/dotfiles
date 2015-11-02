" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
syntax on
set hidden
set nocompatible                      " essential
set history=100000                    " lots of command line history
set cf                                " error files / jumping
set ffs=unix,dos,mac                  " support these files
set isk+=_,$,@,%,#,-                  " none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline                          " make sure modeline support is enabled
set autoread                          " reload files (no local changes only)
set tabpagemax=50                     " open 50 tabs max
"set shellcmdflag=-ic                  " Load bashrc so we have access to aliases

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------
set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" ----------------------------------------------------------------------------
" Keep undo history across sessions, by storing in file.
" ----------------------------------------------------------------------------
set undodir=~/.vim/backups
set undofile

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------
set noshowcmd              " don't display incomplete commands
set nolazyredraw           " turn off lazy redraw
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling
set t_Co=256               " Use 256 colors

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------
set ruler                  " show the cursor position all the time
set cursorline             " Highlight current line
set showmatch              " brackets/braces that is
set mat=10                 " duration to show matching brace (1/5 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set visualbell             " shut the fuck up
set list listchars=tab:\ \ ,trail:·
"set hlsearch

" Put useful info in status line
:set laststatus=2
:set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" ----------------------------------------------------------------------------
" Colors
" ----------------------------------------------------------------------------

if has('gui_running')
    set background=light
else
    set background=dark
endif

"colorscheme desert
"colorscheme vividchalk

let g:solarized_termcolors=256
let g:solarized_visibility="high"
let g:solarized_contrast="high"
colorscheme solarized

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------
set nowrap                 " do not wrap lines
set softtabstop=4          " yep, four
set shiftwidth=4           " ..
set tabstop=4
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
" set formatoptions+=n     " support for numbered/bullet lists
set textwidth=100          "
" set virtualedit=block    " allow virtual edit in visual block ..
set linebreak              " don't wrap textin the middle of a word

" don't outdent hashes
inoremap # #

" It's not like :W is bound to anything anyway
command! W :w

filetype off

" Set new file types so nerdcommenter understand them
au BufNewFile,BufRead *.cls setf cls
au BufNewFile,BufRead *.trigger setf trigger

"For apex files
"au BufEnter *.cls set syntax=java tabstop=4 shiftwidth=4 softtabstop=4 nowrap binary noeol
"au BufEnter *.trigger set syntax=java tabstop=4 shiftwidth=4 softtabstop=4 nowrap binary noeol
"au BufEnter *.cls syn region javaString start=+'+ end=+'+ end=+$+ contains=javaSpecialChar,javaSpecialError,@Spell
"au BufEnter *.trigger syn region javaString start=+'+ end=+'+ end=+$+ contains=javaSpecialChar,javaSpecialError,@Spell
"au BufEnter *.cls exec 'match Todo /\%>120v.\+/'
"au BufEnter *.trigger exec 'match Todo /\%>120v.\+/'
"au BufEnter *.page set tabstop=4 shiftwidth=4 softtabstop=4 nowrap

" For jinja templates
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'FuzzyFinder'
Bundle 'L9'
Bundle 'YouCompleteMe'
Bundle 'ack.vim'
Bundle 'ctrlp'
Bundle 'fugitive'
Bundle 'gitgutter'
Bundle 'golden-ratio'
Bundle 'nerdcommenter'
Bundle 'pep8'
Bundle 'powerline'
Bundle 'pydoc.vim'
Bundle 'pyflakes'
Bundle 'vim-coffee-script'
Bundle 'vim-forcedotcom'
Bundle 'vim-jade'
Bundle 'vim-jinja'

" Misc
execute pathogen#infect()
filetype plugin indent on

let mapleader = ","

" Ctrl-P
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
nnoremap <Leader>f :CtrlP<cr>
nnoremap <Leader>b :CtrlPBuffer<cr>
nnoremap <Leader>a :CtrlPMixed<cr>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc

" Ack: find word under cursor
nnoremap <C-x>f :Ack<CR>

" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------
function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

function! SplitScroll ()
    :wincmd v
    :wincmd w
    execute "normal! \<C-d>"
    :set scrollbind
    :wincmd w
    :set scrollbind
endfu
nmap <leader>sb :call SplitScroll()<CR>

" Make it easier to switch between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" sudo write this
cmap W! w !sudo tee % >/dev/null

" Reload Vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Quickly switch to alternate file
 nnoremap <Leader><Leader> <c-^>

 " Make it easier to switch between windows
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
