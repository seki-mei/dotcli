call plug#begin()
" == Visual ==
Plug 'morhetz/gruvbox'
Plug 'itchyny/vim-cursorword'
Plug 'machakann/vim-highlightedyank'
Plug 'ntpeters/vim-better-whitespace'
" == Other ==
Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
call plug#end()

" ===== theme =====
colorscheme gruvbox
set termguicolors
syntax enable
set background=dark

" ===== plugins =====
"   === vim-highlightedyank ===
let g:highlightedyank_highlight_in_visual = 0
"   === vim-sneak ===
let g:sneak#use_ic_scs = 1 " use own case sensitivity settings
let g:sneak#map_netrw = 1
let g:sneak#prompt = '🐍'
"   === vim-surround ===
let g:surround_no_mappings = 1

" ===== vim only =====
if !has('nvim')
	" ===== gvim =====
	set guioptions-=T    " remove toolbar
	set guioptions-=m    " remove menu bar
	set guioptions-=r    " remove scrollbar

	" ===== cursor shapes =====
	let &t_EI = "\e[2 q" " n mode - block
	let &t_SI = "\e[6 q" " i mode - vertical bar
	let &t_SR = "\e[4 q" " r mode - underline
endif

" ===== cursor =====
set scrolloff=999

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
set shortmess+=F
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
" prevent autoinsert of comments on new lines
autocmd FileType * set formatoptions-=cro
" use arrow key and backspace across newlines
set whichwrap=bs<>[]
" directories for swp files
set nobackup
set directory=/var/tmp,/tmp,~/.vim/swap

" ===== fixes =====
" fix slow exit from insert/visual mode
set timeoutlen=500
" fix slow exit from insert/visual mode. Setting -1 didn't work
set ttimeoutlen=0

" ===== commands =====
:command WS StripWhitespace
:command WSC StripWhitespaceOnChangedLines
:command Q q!

"   === :DiffSaved ===
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ===== keybinds =====
map s                 <Plug>Sneak_s
map S                 <Plug>Sneak_S
map '                 <Plug>Sneak_;
map ,                 <Plug>Sneak_,
map ;                 <Plug>Sneak_,

" surround text object (e.g. hw, hW, a{, hp)
nmap yz               <Plug>Ysurround
" surround line
nmap LL               <Plug>Yssurround
" surround selection
xmap L                <plug>VSurround
" delete delimiter
nmap dz               <Plug>Dsurround
" replace delimiters
nmap cz               <Plug>Csurround

nnoremap Q            :q<CR>
vnoremap Q            <Esc>:q<CR>
" map alt-space to `:`
noremap <Esc><Space>  :
" go back and forth in buffer history list (e.g. from gf)
   nmap <M-Left>      :bN<cr>
   nmap <M-Right>     :bn<cr>
" normal bindings
" C-z and C-S-z use the same key code, remaping C-S-z would overwrite C-z
 noremap <C-z>        u
inoremap <C-z>        <C-o>u
 noremap <C-c>        "+y
inoremap <C-v>        <C-r>+
 noremap <C-s>        <Esc>:update<CR>
inoremap <C-s>        <Esc>:update<CR>

" backspace
inoremap <C-BS>       <c-o>db
inoremap <C-H>        <c-w>
nnoremap <C-H>        db

" keep line centered in edge cases
autocmd CursorMoved * normal! zz
autocmd ModeChanged * normal! zz
 noremap <C-End>      Gzz

" OBSIDIAN_VIMRC_START
 noremap Y            y$
 noremap Z            <C-r>

 noremap <BS>         X
nnoremap <C-BS>       db
 noremap <Del>        x
nnoremap <C-Del>      dw
inoremap <C-Del>      <C-o>dw
nnoremap <C-y>        :%y+<CR>
 noremap <C-x>        "+d
 noremap <C-v>        "+p
" default behaviour: insert tab char
inoremap <Tab>        <Nop>
execute "set <S-Tab>=\e[Z"
inoremap <S-Tab>      <Nop>

 noremap j            h
 noremap h            i
 noremap gh           gi
 noremap H            I

 noremap i            gk
 noremap I            5gk
 noremap <PageUp>     5gk
inoremap <PageUp>     <Esc>5gk
 noremap k            gj
 noremap K            5gj
 noremap <PageDown>   5gj
inoremap <PageDown>   <Esc>5gj

vnoremap <Up>         <Esc>
inoremap <Up>         <Esc>
 noremap <S-Up>       <Nop>
inoremap <S-Up>       <Nop>
 noremap <S-PageUp>   <Nop>
inoremap <S-PageUp>   <Nop>
vnoremap <Down>       <Esc>
inoremap <Down>       <Esc>
 noremap <S-Down>     <Nop>
inoremap <S-Down>     <Nop>
 noremap <S-PageDown> <Nop>
inoremap <S-PageDown> <Nop>

 noremap <C-j>        <C-Left>
inoremap <C-j>        <C-O><C-Left>
 noremap <C-l>        <C-Right>
inoremap <C-l>        <C-O><C-Right>

 noremap <Home>       ^
inoremap <Home>       <C-O>^
 noremap <End>        $
inoremap <End>        <C-O>$

" insert space
nnoremap [<space>     i<space><esc>l
nnoremap ]<space>     a<space><esc>h
" OBSIDIAN_VIMRC_END

" DIFF_SEEK
"difference reason: obsidian ran into issue were marks would return to first char in line
" insert line above/below
nnoremap [o           mcO<Esc>`c
nnoremap ]o           mco<Esc>`c
" overwrite line above/below with paste
nnoremap [p           mc<Up>Vp`c
nnoremap ]p           mc<Down>Vp`c
" erase contents of line above/below
nnoremap [d           mc<Up>0D`c
nnoremap ]d           mc<Down>0D`c

noremap <CR>          <Nop>
noremap <Space>       <Nop>
noremap <C-Space>     <Nop>

" ===== autocomplete =====
inoremap <Up>         <C-P>
inoremap <Down>       <C-N>

" === CTRL ===
noremap x             <Nop>
let keys = 'abcdefghijklmnopqrstuvwxyz'
for i in split(keys, '\zs')
	execute 'noremap x' . i . ' <C-' . i . '>'
endfor
