set encoding=utf-8
call plug#begin()
" == visual
Plug 'morhetz/gruvbox'
Plug 'itchyny/vim-cursorword'
Plug 'machakann/vim-highlightedyank'
Plug 'ntpeters/vim-better-whitespace'
" == other
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
" == syntax hl
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'wuelnerdotexe/vim-astro'
if has('nvim')
	Plug 'epwalsh/obsidian.nvim'
endif
call plug#end()

" ===== theme
colorscheme gruvbox
set termguicolors
syntax enable
set background=dark

" ===== plugins
"   === vim-highlightedyank
let g:highlightedyank_highlight_in_visual = 0
"   === vim-sneak
let g:sneak#use_ic_scs = 1 " use own case sensitivity settings
let g:sneak#map_netrw = 1
let g:sneak#prompt = '🐍'
"   === vim-surround
let g:surround_no_mappings = 1

" ===== vim only
if !has('nvim')
	" ===== gvim
	set guioptions-=T    " remove toolbar
	set guioptions-=m    " remove menu bar
	set guioptions-=r    " remove scrollbar

	" ===== cursor shapes
	let &t_EI = "\e[2 q" " n mode - block
	let &t_SI = "\e[6 q" " i mode - vertical bar
	let &t_SR = "\e[4 q" " r mode - underline
endif

" ===== cursor
set scrolloff=999

" ===== search
set incsearch
set ignorecase
set smartcase "ignore case unless search query contains uppercase letter
set nohlsearch

" ===== highliting
au BufNewFile,BufRead *.qss setfiletype css

" ===== completion
set ofu=syntaxcomplete#Complete "enable completion
set wildmenu "completion menu for `:`

" ===== indent
set noexpandtab
set shiftwidth=0 "0: uses tabstop value
set tabstop=2
set list
set listchars=tab:••\|
set showbreak=↪↪↪↪

" ===== title
set title
set titlestring=%t

" ===== statusline
set noshowmode
set shortmess+=F
set showcmd
set laststatus=2

function! ConditionalCwd()
	let l:cwd = getcwd()
	let l:home = expand('~')
	if l:cwd ==# l:home
		return ''
	else
		return fnamemodify(l:cwd, ':~') . ' '
	endif
endfunction
" set statusline=%=%{FugitiveStatusline()}\ %{ConditionalCwd()}%t\ %m%r
" set statusline=%=%{ConditionalCwd()}%t\ %m%r
set statusline=%=%t\ %m%r

if (&ft=='markdown')
	set statusline+=%{wordcount().words}\W
endif

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

" ===== other
" prevent autoinsert of comments on new lines
autocmd FileType * set formatoptions-=cro
" use arrow key and backspace across newlines
set whichwrap=bs<>[]
" directories for swp files
set nobackup
set directory=/var/tmp,/tmp,~/.vim/swap

" ===== fixes
" fix slow exit from insert/visual mode
" set timeoutlen=1000
" fix slow exit from insert/visual mode. Setting -1 didn't work
set ttimeoutlen=0

" ===== commands
:command! Q q!
:command! WS StripWhitespace
:command! WSC StripWhitespaceOnChangedLines
:command! VRC !vim $HOME/.vimrc
:command! S !vim $HOME/Obsidian/Sketchpad.md
nnoremap <F1> :silent !vim "$HOME/Obsidian/Info/Hotkeys.md"<CR>:redraw!<CR>

"   === :DiffSaved
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" fzf
function! FzfOpen()
	silent !xdg-open "$(fzf --no-multi --preview='bat --theme=gruvbox-dark --color=always --plain {}')"
	redraw!
endfunction
nnoremap <space>f :call FzfOpen()<CR>

" ===== keybinds
" some free, no-mod sequences:
	" <fnum> q' g<space>
map s                  <Plug>Sneak_s
map S                  <Plug>Sneak_S
map '                  <Plug>Sneak_;
map ,                  <Plug>Sneak_,
map ;                  <Plug>Sneak_,

" surround text object (e.g. hw, hW, a{, hp)
nmap yz                <Plug>Ysurround
" surround line
nmap yzz               <Plug>Yssurround
" surround selection
vmap Y                 <plug>VSurround
" delete delimiter
nmap dz                <Plug>Dsurround
" replace delimiters
nmap cz                <Plug>Csurround

nnoremap Q             :q<CR>
vnoremap Q             <Esc>:q<CR>

" map alt-space to `:`
 noremap <Esc><Space>  :
inoremap <Esc><Space>  <Esc>:
 noremap q<Space>      q:

" go back and forth in buffer history list (e.g. from gf)
   nmap <M-Left>       :bN<cr>
   nmap <M-Right>      :bn<cr>
" stahdard bindings
" C-z and C-S-z use the same key code, remaping C-S-z would overwrite C-z
 noremap <C-z>         u
inoremap <C-z>         <C-o>u
 noremap <C-c>         "+y
" there are issues when pasting large amounts of text with "+p as a keybind
nnoremap <C-v>         a<c-r>+
vnoremap <C-v>         c<C-r>+
inoremap <C-v>         <C-r>+
 noremap <C-s>         <Esc>:up<CR>
inoremap <C-s>         <Esc>:up<CR>

" backspace
inoremap <C-BS>        <c-o>db
inoremap <C-H>         <c-w>
nnoremap <C-H>         db

execute "set <S-Tab>=\e[Z"
" inoremap <Tab>        <C-n>
" inoremap <S-Tab>      <C-p>
inoremap <S-Tab>       <C-d>

if empty($TERMUX_VERSION)
	nnoremap <C-y>       :%y+<CR>
endif

" keep line centered in edge cases
 autocmd CursorMoved * normal! zz
 autocmd InsertEnter * normal! zz
 noremap G             Gzz
 noremap <C-End>       Gzz

" OBSIDIAN_VIMRC_START
nnoremap Y             y$
noremap Z              <C-r>

noremap <BS>           X
nnoremap <C-BS>        db
nnoremap <Del>         x
noremap [3~          x
nnoremap <C-Del>       dw
nnoremap [3;5~       dw
inoremap <C-Del>       <C-O>dw
inoremap [3;5~       <C-O>dw

noremap <C-x>          "+d

noremap j              h
noremap h              i
noremap gh             gi
nnoremap g'            g;
noremap H              I

inoremap <Up>          <Esc>gk
noremap i              gk
noremap I              5gk
noremap <PageUp>       5gk
inoremap <PageUp>      <Esc>5gk

inoremap <Down>        <Esc>gj
noremap k              gj
noremap K              5gj
noremap <PageDown>     5gj
inoremap <PageDown>    <Esc>5gj

noremap <S-Up>         <Nop>
inoremap <S-Up>        <Esc>
noremap <S-PageUp>     <Nop>
inoremap <S-PageUp>    <Esc>
noremap <S-Down>       <Nop>
inoremap <S-Down>      <Esc>
noremap <S-PageDown>   <Nop>
inoremap <S-PageDown>  <Esc>

nnoremap U             <Nop>
nnoremap M             <Nop>
nnoremap X             <Nop>

noremap <CR>           <Nop>
noremap <Space>        <Nop>
noremap <C-Space>      <Nop>

noremap <C-j>          <C-Left>
noremap <C-l>          <C-Right>

" noremap <C-i>          5gk
" inoremap <C-i>         <Esc>k
noremap <C-Up>         5gk
inoremap <C-Up>        <Esc>k

" noremap <C-k>          5gj
" inoremap <C-k>         <Esc>j
noremap <C-Down>       5gj
inoremap <C-Down>      <Esc>j

noremap <Home>         ^

noremap +              <C-a>
noremap -              <C-x>

" xy<motion> -> copy to clipborad, xd<motion> delete to clipboard, xc<motion>...
nnoremap x              "+
vnoremap x              "+
nnoremap X              "0
vnoremap X              "0
nnoremap <space>v      <C-v>

nnoremap gO            moO<Esc>`o
nnoremap go            moo<Esc>`o
" OBSIDIAN_VIMRC_END
" insert-mode C-O doesn't work in obsidian
inoremap <C-Del>       <C-O>dw
inoremap <C-j>         <C-O><C-Left>
inoremap <C-l>         <C-O><C-Right>
inoremap <Home>        <C-O>^
"obsidian doesn't like g_
 noremap <End>         g_
" inoremap <End>        <C-O>g_
inoremap <End>         <C-O>$

noremap L              <C-w>
noremap XQ             ZQ
noremap XX             ZZ

" fix timeout delay
inoremap <nowait> <Esc> <Esc>
vnoremap <nowait> <Esc> <Esc>
