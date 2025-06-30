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
Plug 'tpope/vim-fugitive'
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
" set statusline=%=%t\ %m%r
function! ConditionalCwd()
	let l:cwd = getcwd()
	let l:home = expand('~')
	if l:cwd ==# l:home
		return ''
	else
		return fnamemodify(l:cwd, ':~') . ' '
	endif
endfunction
set statusline=%=%{FugitiveStatusline()}\ %{ConditionalCwd()}%t\ %m%r

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
:command! WS StripWhitespace
:command! WSC StripWhitespaceOnChangedLines
:command! Q q!

" nnoremap Xhk :!vim +"/vim" "$HOME/Obsidian/Info/Hotkeys.md"<CR>
nnoremap Xh :!vim "$HOME/Obsidian/Info/Hotkeys.md"<CR>
:command! VRC !vim $HOME/.vimrc
:command! S !vim $HOME/Obsidian/Sketchpad.md
" :command -nargs=1 HK execute '!vim +"/' . escape(<q-args>, '\/.*$^~[]#') . '" "$HOME/Obsidian/Info/Hotkeys.md"'

" open hotkeys file with /arg. If no arg given, search for /# vim
:command! -nargs=? HK call HKOpen(<f-args>)
function! HKOpen(...) abort
  let pattern = a:0 > 0 ? a:1 : '# vim'
  let pattern = escape(pattern, '\/.*#$^~[]')
  execute '!vim +"/' . pattern . '" "$HOME/Obsidian/Info/Hotkeys.md"'
endfunction

" open url under cursor
function! OpenURLUnderCursor()
	let line = getline('.')
	let col = col('.') - 1
	" Regex for a very liberal URL match
	let url_pattern = 'https\?://[^ \t\n\r<>"''(){}\[\]]\+'
	" Look for all matches on the line
	let urls = []
	let pos = 0
	while pos >= 0 && pos < len(line)
		let match = matchstrpos(line, url_pattern, pos)
		if empty(match) || match[1] == -1
			break
		endif
		call add(urls, match)
		let pos = match[1] + len(match[0])
	endwhile
	" Look for match that includes the cursor
	for match in urls
		let [url, start] = [match[0], match[1]]
		let end = start + len(url)
		if col >= start && col < end
			redraw!
			call system('firefox ' . shellescape(url) . ' &')
			redraw!
			return
		endif
	endfor
	echo "No URL found under cursor"
endfunction
nnoremap <silent> Xu :call OpenURLUnderCursor()<CR>

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
nmap yzz              <Plug>Yssurround
" surround selection
vmap Y                <plug>VSurround
" delete delimiter
nmap dz               <Plug>Dsurround
" replace delimiters
nmap cz               <Plug>Csurround

nnoremap Q            :q<CR>
vnoremap Q            <Esc>:q<CR>

" map alt-space to `:`
noremap <Esc><Space>  :
noremap q<Space>      q:

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
 autocmd InsertEnter * normal! zz
 noremap G            Gzz
 noremap <C-End>      Gzz

" OBSIDIAN_VIMRC_START
nnoremap Y            y$
 noremap Z            <C-r>

 noremap <BS>         X
nnoremap <C-BS>       db
 noremap <Del>        x
nnoremap <C-Del>      dw
inoremap <C-Del>      <C-o>dw

if empty($TERMUX_VERSION)
  " only remap if not termux
	nnoremap <C-y>        :%y+<CR>
endif

 noremap <C-x>        "+d
 noremap <C-v>        "+p
" default behaviour: insert tab char
" inoremap <Tab>        <Nop>
execute "set <S-Tab>=\e[Z"
inoremap <S-Tab>      <Nop>

 noremap j            h
 noremap h            i
 noremap gh           gi
nnoremap g'           g;
 noremap H            I

 noremap i            gk
 noremap I            5gk
 noremap <PageUp>     5gk
inoremap <PageUp>     <Nop>
 noremap k            gj
 noremap K            5gj
 noremap <PageDown>   5gj
inoremap <PageDown>   <Nop>

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

nnoremap U            <Nop>
nnoremap M            <Nop>
nnoremap X            <Nop>

noremap <CR>          <Nop>
noremap <Space>       <Nop>
noremap <C-Space>     <Nop>

 noremap <C-j>        <C-Left>
inoremap <C-j>        <C-O><C-Left>
 noremap <C-l>        <C-Right>
inoremap <C-l>        <C-O><C-Right>

 noremap <Home>       ^
inoremap <Home>       <C-O>^
 noremap <End>        g_
inoremap <End>        <C-O>g_

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

" ===== autocomplete =====
" inoremap <Up>         <C-P>
" inoremap <Down>       <C-N>
" inoremap <S-Tab>      <C-P>
" inoremap <Tab>        <C-N>

" === CTRL ===
noremap x             <Nop>
let keys = 'abcdefghijklmnopqrstuvwxyz'
for i in split(keys, '\zs')
	execute 'noremap x' . i . ' <C-' . i . '>'
endfor

noremap L              <C-w>
noremap XQ             ZQ
noremap XX             ZZ
