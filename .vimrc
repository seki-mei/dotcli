call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'justinmk/vim-sneak'
Plug 'itchyny/vim-cursorword'
Plug 'machakann/vim-highlightedyank'
Plug 'ntpeters/vim-better-whitespace'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'vim-airline/vim-airline'
call plug#end()

" ===== theme =====
colorscheme gruvbox
set termguicolors
syntax enable
set background=dark

" ===== vim-highlightedyank =====
let g:highlightedyank_highlight_in_visual = 0

" ===== vim-sneak =====
" sticking to default mode because label mode doesn't instantly apply operator
let g:sneak#use_ic_scs = 1 " use own case sensitivity settings
let g:sneak#map_netrw = 1
let g:sneak#prompt = '🐍'

map s <Plug>Sneak_s
map S <Plug>Sneak_S
map ' <Plug>Sneak_;
map , <Plug>Sneak_,
map ; <Plug>Sneak_,

" ===== vim-surround =====
let g:surround_no_mappings = 1
" surround text object (e.g. hw, hW, a{, hp)
nmap yz  <Plug>Ysurround
" surround line
nmap LL <Plug>Yssurround
" surround selection
xmap L   <plug>VSurround
" delete delimiter
nmap dz  <Plug>Dsurround
" replace delimiters
nmap cz  <Plug>Csurround

if !has('nvim')
	" ===== gvim =====
	set background=dark
	set guioptions-=T    " remove toolbar
	set guioptions-=m    " remove menu bar
	set guioptions-=r    " remove scrollbar

	" ===== cursor shapes =====
	let &t_SI = "\e[6 q" " Insert mode - vertical bar
	let &t_SR = "\e[4 q" " Replace mode - underline
	let &t_EI = "\e[2 q" " Normal mode - block
endif

" ===== cursor =====
set scrolloff=999
" set cursorline

" ===== search =====
set incsearch
set ignorecase
set smartcase "ignore case unless search query contains uppercase letter
set nohlsearch

" ===== completion =====
set ofu=syntaxcomplete#Complete "enable completion
set wildmenu "completion menu for `:`

" ===== indent =====
set noexpandtab
set shiftwidth=0
set tabstop=2
set list
set listchars=tab:••\|
set showbreak=↪↪↪↪

" ===== statusline =====
set noshowmode
set noruler
set showcmd

set laststatus=2
set statusline=%=%t\ %m%r
highlight! link StatusLineNC Normal
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

" ===== other =====
autocmd FileType * set formatoptions-=cro
" use arrow key and backspace across newlines
set whichwrap=bs<>[]
" directories for swp files
set nobackup
set directory=/var/tmp,/tmp,~/.vim/swap

" ===== fixes =====
" fix slow exit from insert mode
set timeoutlen=500
" fix slow exit from insert mode and visual mode. Tried -1 and it didn't work
set ttimeoutlen=0
" json syntax highlighting
au BufNewFile,BufRead *.json set ft=json syntax=javascript

" ===== :DiffSaved =====
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ===== keybinds =====
nnoremap Q :q<CR>
vnoremap Q <Esc>:q<CR>
" map alt-space to `:`
noremap <Esc><Space> :
" go back and forth in buffer history list (e.g. from gf)
nmap <M-Left> :bN<cr>
nmap <M-Right> :bn<cr>
" normal bindings
" C-z and C-S-z use the same key code, remaping C-S-z would overwrite C-z
noremap  <C-z> u
inoremap <C-z> <C-o>u
noremap  <C-c> "+y
inoremap <C-v> <C-r>+
noremap  <C-s> <Esc>:update<CR>
inoremap <C-s> <Esc>:update<CR>

" backspace
inoremap <C-BS> <c-o>db
inoremap <C-H> <c-w>
nnoremap <C-H> db

nnoremap <Up> <Up>zz
nnoremap <Down> <Down>zz
noremap <C-End> Gzz
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap w wzz
nnoremap W Wzz
nnoremap e ezz
nnoremap E Ezz
nnoremap b bzz
nnoremap B Bzz

" OBSIDIAN_VIMRC_START
noremap  <BS> X
nnoremap <C-BS> db
noremap  <Del> x
nnoremap <C-Del> dw
inoremap <C-Del> <C-o>dw
nnoremap <C-y> :%y+<CR>
noremap  <C-x> "+d
noremap  <C-v> "+p
inoremap <Tab> <Nop>
" inoremap <Tab> <C-O>
" nnoremap <Tab> >>
" vnoremap <Tab> >
execute "set <S-Tab>=\e[Z"
inoremap <S-Tab> <Nop>
" inoremap <S-Tab> <C-O><<
" nnoremap <S-Tab> <<
" vnoremap <S-Tab> <

noremap Y y$
noremap Z <C-r>
noremap h i
noremap gh gi
noremap j h
noremap i gkzz
noremap k gjzz
noremap H I
noremap <C-j> <C-Left>
inoremap <C-j> <C-O><C-Left>
noremap <C-l> <C-Right>
inoremap <C-l> <C-O><C-Right>
noremap I 5gkzz
noremap <PageUp> 5gkzz
inoremap <PageUp> <C-O>5gkzz
" zz in 5gjzz doesn't work if last line interrupts
noremap K gjzzgjzzgjzzgjzzgjzz
noremap <PageDown> gjzzgjzzgjzzgjzzgjzz
inoremap <PageDown> <C-O>gjzzgjzzgjzzgjzzgjzz
" nnoremap <PageUp> <C-u>
" nnoremap <PageDown> <C-d>
noremap <Home> ^
inoremap <Home> <C-O>^
vnoremap <Up> <Esc>
inoremap <Up> <Esc>
vnoremap <Down> <Esc>
inoremap <Down> <Esc>

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

" ===== autocomplete =====
inoremap <Up> <C-P>
inoremap <Down> <C-N>

" === CTRL ===
noremap x <Nop>
let keys = 'abcdefghijklmnopqrstuvwxyz'
for i in split(keys, '\zs')
	execute 'noremap x' . i . ' <C-' . i . '>'
endfor

" ===== vim-airline =====
" set noshowmode
" set shortmess+=F
" let g:airline_powerline_fonts = 1
" let g:airline_skip_empty_sections = 1
" let g:airline_section_a=''
" let g:airline_section_b=''
" let g:airline_section_x=''
" let g:airline_section_y=''
" let g:airline_section_z='%p%%%#__accent_bold#'
" let g:airline_mode_map = {}
" let g:airline_mode_map['n'] = 'N'
" let g:airline_mode_map['v'] = 'V'
" let g:airline_mode_map['V'] = 'V'
" let g:airline_mode_map['']= 'B'
" let g:airline_mode_map['i'] = 'I'
" let g:airline_mode_map['R'] = 'R'
" let g:airline_mode_map['c'] = 'C'

" ===== blink-column =====
" function! BlinkCursorColumn(times, interval)
" 	let i = 0
" 	while i < a:times
" 		set cursorcolumn
" 		redraw
" 		execute 'sleep ' . a:interval . 'm'
" 		set nocursorcolumn
" 		redraw
" 		execute 'sleep ' . a:interval . 'm'
" 		let i += 1
" 	endwhile
" endfunction
" "
" highlight CursorColumn guibg=#d65d0e
" " blink column 3 times, 100ms per phase
" nnoremap zx :call BlinkCursorColumn(3, 100)<CR>
