" Maintainer:   Markus Mottl  <markus.mottl@gmail.com>
" URL:          https://bitbucket.org/mmottl/vim-files

" I want Vim, not Vi
set nocompatible

" Don't want to type indentation
set autoindent

" Automatically write buffer before special actions
set autowrite

" Add a linemarker at 80
augroup BgHighlight
  autocmd!
  autocmd BufWinEnter,WinEnter * set colorcolumn=80
  autocmd BufWinLeave,WinLeave * set colorcolumn=0
augroup END

" Tabs are evil
set expandtab

" Set formatting of text and comments
set formatoptions=tn1

" My default format program
set formatprg=fmt\ -w\ 80\ -s

" Only hide invisible buffers (keeps their editing state)
set hidden

" Command line history
set history=1000

" Highlight matches
set hlsearch

" Set options for autocompletion
set noinfercase

" Always want statusline
set laststatus=2

" When we do wrap visibly (by calling set wrap), break in reasonable places
set linebreak

" Set statusline
set statusline=%F%m%r%h%w\ %y\ [pos=%l,%c%V]\ [len=%L\ (%p%%)]

" Don't display macro steps
set lazyredraw

" Don't move cursor to first line when scrolling
set nostartofline

" Want mouse support
set mouse=a

" Maintain some more context around the cursor
set scrolloff=3
set sidescrolloff=3

" Not too deep, not too shallow
set shiftwidth=2

" Show size of visual selection
set showcmd

" Show matching braces
set showmatch

" We want fancy tab handling
set smarttab

" Want better buffer handling in quickfix mode
set switchbuf=useopen,usetab,split

" Tabs are 2 characters
set tabstop=2

" Don't wrap words
set textwidth=0

" Set the terminal title
set title

" Remember some stuff after quiting vim: marks, registers, searches, buffer list
set viminfo='20,<50,s10,h,%

" No beeps - don't want to annoy neighbors
set visualbell

" Expand the command line using tab
set wildmenu
set wildmode=list:longest,full

" Use UTF-8
set encoding=utf-8
set termencoding=utf-8
if &modifiable
  set fileencoding=utf-8
endif

" Backspacing + deleting and wrapping of lines
set backspace=start,eol,indent whichwrap=b,s,l,h,<,>,[,]
map <BS> dh
map  <BS>
map!  <BS>
map  [3~ <Del>
map! [3~ <Del>

" File types
:syntax on
:filetype plugin indent on

" Set autoclose pairs for autoclose plugin
let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"'}

" Better syntax highlighting for shell scripts.
" Syntax highlight shell scripts as per POSIX,
" not the original Bourne shell, which very few use
let g:is_posix = 1

" Colors for color xterms
if has("terminfo")
  set t_Co=8
  set t_Sf=[3%p1%dm
  set t_Sb=[4%p1%dm
  set <S-Up>=O2A
  set <S-Down>=O2B
  set <S-Left>=O2D
  set <S-Right>=O2C
else
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Use my color preferences
set background=dark
colorscheme markus

" Ex-mode is pretty dumb, remap Q to reformat the current paragraph
nnoremap Q gqip

" Function key settings - 'make'-shortcuts
map <F5> :cp<CR>
map <F6> :cn<CR>

" Have <F2> toggle paste
set pastetoggle=<F2>

" Have <F3> toggle spelling mode
nmap <F3> :setlocal invspell spelllang=en_us<CR>

" , is a more convenient leader than \
let maplocalleader = ",,"
let mapleader = ","

" Underline the current line with - in normal mode
nnoremap <leader>u yyp<c-v>$r-

" Underline the current line with = in normal mode
nnoremap <leader>U yyp<c-v>$r=

" OCaml stuff
let no_ocaml_comments = 1
set makeprg=ocamlbuild\ ${BUILDFLAGS}\ -use-ocamlfind\ all.otarget
"set makeprg=omake\ -j\ 8

" Remove GUI-nonsense
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Always show the menu, insert longest match
set completeopt=menu,longest

" Ignore irrelevant suffixes for filename completion
set wildignore+=*.a,*.bak,*~,*.swp,*.o,*.info,*.aux,*.dvi,*.bbl,*.blg,*.brf,*.cb,*.ind,*.idx,*.ilg,*.inx,*.out,*.toc,*.cmi,*.cmo,*.cma,*.cmx,*.cmp,*.cmxa,*.cmxs,*.omc,*.annot,*.exe,*.native,*.byte,*.bc,*.sums,*.spit,*.spot,*.clib

" Change directories automatically
autocmd BufEnter * lcd %:p:h

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Our shell code looks like a scheme programmer made up all the names
autocmd FileType sh set iskeyword=~,@,48-57,_,192-255,-

" Set location for NetrW bookmarks and history
let g:netrw_home=$HOME

" Syntastic
" let g:syntastic_ocaml_use_ocamlc = 1
let g:syntastic_ocaml_use_ocamlbuild = 1
let g:syntastic_ocaml_checkers = ['merlin']

" Currently disabled
let g:pathogen_disabled = ['syntastic', 'ocamlmerlin']
set ofu=syntaxcomplete#Complete

" Load Pathogen
call pathogen#infect()

" Load matchit
runtime! macros/matchit.vim

" SnipMate stuff
let g:snips_author = 'Markus Mottl'

" MRU-functionality
nnoremap <leader>m :MRU<CR>
let MRU_Max_Entries = 1000

" FuF-functionality
nnoremap <leader>ff :FufFile<CR>
nnoremap <leader>fd :FufDir<CR>
nnoremap <leader>fb :FufBuffer<CR>
nnoremap <leader>fC :FufCoverageFile<CR>
nnoremap <leader>fl :FufLine<CR>
nnoremap <leader>fj :FufJumpList<CR>
nnoremap <leader>fc :FufChangeList<CR>

" NERDTree
nnoremap <leader>n :NERDTree<CR>

" Make
nnoremap <leader>M :make<CR>

" Turn off match highlighting
nnoremap <leader>h :nohlsearch<CR>

" Save quickly
nnoremap <leader>w :w<CR>

" Choosewin functionality
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## e0475008ba118d73abb1e026e269617a ## you can edit, but keep this line
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line

if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
endif
