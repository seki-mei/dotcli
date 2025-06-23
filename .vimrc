call plug#begin()
" Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'itchyny/vim-cursorword'
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/vim-peekaboo'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-eunuch'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
call plug#end()

" ===== muscle-memory help
map : <Nop>

" ===== theme =====
colorscheme gruvbox
set termguicolors
syntax enable
set background=dark

" ===== blink-column =====
function! BlinkCursorColumn(times, interval)
	let i = 0
	while i < a:times
		set cursorcolumn
		redraw
		execute 'sleep ' . a:interval . 'm'
		set nocursorcolumn
		redraw
		execute 'sleep ' . a:interval . 'm'
		let i += 1
	endwhile
endfunction
"
highlight CursorColumn guibg=#d65d0e
" blink column 3 times, 100ms per phase
nnoremap zx :call BlinkCursorColumn(3, 100)<CR>

" ===== :DiffSaved =====
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ===== vim-highlightedyank =====
let g:highlightedyank_highlight_in_visual = 0

" ===== vim-surround =====
" surround text object (e.g. hw, hW, a{, hp)
nmap L  <Plug>Ysurround
nmap dL  <Plug>Ysurround
" surround line
nmap LL <Plug>Yssurround
" surround selection
xmap L   <plug>VSurround
" delete delimiter
nmap dz  <Plug>Dsurround
nmap dL  <Plug>Dsurround
" replace delimiters
nmap cz  <Plug>Csurround
nmap cL  <Plug>Csurround

" ===== vim-sneak =====
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1 " use own case sensitivity settings
let g:sneak#prompt = '🐍'
let g:sneak#target_labels = "0123456789"
" let g:sneak#s_next = 1 " repeat by pressing s

map s <Plug>Sneak_s
map S <Plug>Sneak_S
map ' <Plug>Sneak_;
map , <Plug>Sneak_,
" label-mode
" nmap s <Plug>SneakLabel_s
" nmap S <Plug>SneakLabel_S

" ===== vim-airline =====
set noshowmode
set shortmess+=F
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_section_a=''
let g:airline_section_b=''
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z=''
" let g:airline_section_z='%p%%%#__accent_bold#'
let g:airline_mode_map = {}
let g:airline_mode_map['n'] = 'N'
let g:airline_mode_map['v'] = 'V'
let g:airline_mode_map['V'] = 'V'
let g:airline_mode_map['']= 'B'
let g:airline_mode_map['i'] = 'I'
let g:airline_mode_map['R'] = 'R'
let g:airline_mode_map['c'] = 'C'


" ===== gvim =====
set background=dark
set guioptions-=T    " remove toolbar
set guioptions-=m    " remove menu bar
set guioptions-=r    " remove scrollbar

" ===== cursor shapes =====
let &t_SI = "\e[6 q" " Insert mode - vertical bar
let &t_SR = "\e[4 q" " Replace mode - underline
let &t_EI = "\e[2 q" " Normal mode - block

" ===== indent =====
set noexpandtab
set shiftwidth=0
set tabstop=2
set list
set listchars=tab:••\|
" set listchars=tab:--⇥
set showbreak=↪


" ===== search =====
set incsearch
set ignorecase
set smartcase "ignore case unless search query contains uppercase letter

" ===== statusline =====
set noruler
set showcmd


set laststatus=2
" highlight! link StatusLine Normal
highlight! link StatusLineNC Normal
set statusline=%=%t\ %m%r
highlight! link StatusLineNormal GruvboxFg1
highlight! link StatusLineModified GruvboxAqua

augroup StatusLineHighlight
  autocmd!
  autocmd BufEnter,BufWritePost,InsertLeave * call UpdateStatuslineHighlight()
  autocmd TextChanged,TextChangedI * call UpdateStatuslineHighlight()
augroup END

function! UpdateStatuslineHighlight()
  if &modified
    highlight! link StatusLine StatusLineModified
  else
    highlight! link StatusLine StatusLineNormal
  endif
endfunction

" ===== autodetect filetype
function! CheckFileType()
    if exists("b:countCheck") == 0
        let b:countCheck = 0
    endif
    let b:countCheck += 1
    if &filetype == "" && b:countCheck > 40 && b:countCheck < 200
        filetype detect
    elseif b:countCheck >= 200 || &filetype != ""
        autocmd! newFiletypeDetection
    endif
endfunction

augroup newFiletypeDetection
    autocmd CursorMovedI * call CheckFileType()
augroup END

" ===== cursor =====
set scrolloff=999
set cursorline

" ===== other =====
set timeoutlen=1500
autocmd FileType * set formatoptions-=cro
" directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backupf
set whichwrap=bs<>[] "use arrow key and backspace across newlines
" set ofu=syntaxcomplete#Complete "enable completion

" ===== fixes =====
" fix slow exit of insert mode
set timeoutlen=500
" fix slow exit of visual mode. Tried -1 and it didn't work
set ttimeoutlen=0
" Add json syntax highlighting
au BufNewFile,BufRead *.json set ft=json syntax=javascript

nnoremap <C-c> "+y
vnoremap <C-c> "+y
inoremap <C-v> <C-r>+
nnoremap <C-z> u
vnoremap <C-z> u
inoremap <C-z> <C-o>u
nnoremap <C-s> :update<CR>
vnoremap <C-s> <Esc>:update<CR>
inoremap <C-s> <Esc>:update<CR>

" map alt-space to :
nnoremap <Esc><Space> :
vnoremap <Esc><Space> :


nnoremap Q :q<CR>
vnoremap Q <Esc>:q<CR>

" go back and forth in buffer history list (e.g. from gf)
nmap <M-Left> :bN<cr>
nmap <M-Right> :bn<cr>

" C-z and C-S-z use the same key code, remaping C-S-z would overwrite C-z
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>

nnoremap <Tab> >>
vnoremap <Tab> >
execute "set <S-Tab>=\e[Z"
nnoremap <S-Tab> <<
vnoremap <S-Tab> <
inoremap <S-Tab> <C-d>

" backspace
inoremap <C-BS> <c-o>db
inoremap <C-H> <c-w>
nnoremap <C-H> db


" OBSIDIAN_VIMRC_START
nnoremap <BS> X
vnoremap <BS> X
nnoremap <C-BS> db
nnoremap <Del> x
vnoremap <Del> x
nnoremap <C-Del> dw
inoremap <C-Del> <C-o>dw
nnoremap <C-y> :%y+<CR>
vnoremap <C-x> "+d
vnoremap <C-v> "+p
nnoremap <C-v> "+p
noremap Y y$
noremap Z <C-r>
noremap h i
noremap gh gi
noremap j h
noremap i gk
noremap k gj
noremap H I
nnoremap <C-j> <C-Left>
vnoremap <C-j> <C-Left>
inoremap <C-j> <C-O><C-Left>
nnoremap <C-l> <C-Right>
vnoremap <C-l> <C-Right>
inoremap <C-l> <C-O><C-Right>
nnoremap I 5gk
vnoremap I 5gk
nnoremap K 5gj
vnoremap K 5gj
noremap <Home> ^
" noremap ' ;
inoremap <Up> <Esc>
vnoremap <Up> <Esc>
inoremap <Down> <Esc>
vnoremap <Down> <Esc>
" inoremap <Left> <Esc>
" vnoremap <Left> <Esc>
" inoremap <Right> <Esc>
" vnoremap <Right> <Esc>

" insert space
nnoremap [<space> i<space><esc>l
nnoremap ]<space> a<space><esc>h
" OBSIDIAN_VIMRC_END

" DIFF_SEEK
"difference reason: obsidian ran into issue were marks would return to first char in line
" insert line above/below
nnoremap [o mcO<Esc>`c
nnoremap ]o mco<Esc>`c
" overwrite line above/below with paste
nnoremap [p mc<Up>Vp`c
nnoremap ]p mc<Down>Vp`c
" erase contents of line above/below
nnoremap [d mc<Up>0D`c
nnoremap ]d mc<Down>0D`c

nnoremap <CR> <Nop>
nnoremap <Space> <Nop>

" difference reason: escape character, 'endfor' unsupported
" === CTRL ===
nnoremap x <Nop>
vnoremap x <Nop>
nnoremap X <Nop>
vnoremap X <Nop>

let keys = 'abcdefghijklmnopqrstuvwxyz'
for i in split(keys, '\zs')
	execute 'nnoremap x' . i . ' <C-' . i . '>'
	execute 'vnoremap x' . i . ' <C-' . i . '>'
endfor
