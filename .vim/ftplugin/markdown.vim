" onoremap hh :<c-u>execute "normal! ?^#\r:nohlsearch\rjV/^#\rk"<CR>
" onoremap ah :<c-u>execute "normal! ?^#\r:nohlsearch\rV/^#\rk"<CR>

nnoremap <buffer> } :call search('^#\+ ', 'W')<CR>
nnoremap <buffer> { :call search('^#\+ ', 'bW')<CR>

xnoremap <buffer> } :call search('^#\+ ', 'W')<CR>
xnoremap <buffer> { :call search('^#\+ ', 'bW')<CR>

onoremap <buffer> } :call search('^#\+ ', 'W')<CR>
onoremap <buffer> { :call search('^#\+ ', 'bW')<CR>


nnoremap <buffer> } :call search('^#\+ ', 'W')<CR>
nnoremap <buffer> { :call search('^#\+ ', 'bW')<CR>
xnoremap <buffer> } :call search('^#\+ ', 'W')<CR>
xnoremap <buffer> { :call search('^#\+ ', 'bW')<CR>
onoremap <buffer> } :call search('^#\+ ', 'W')<CR>
onoremap <buffer> { :call search('^#\+ ', 'bW')<CR>

function! s:MarkdownHeadingObject(around)
  " Find the heading at or above cursor (don't move cursor)
  let heading_line = search('^#\+ ', 'bcnW')
  if heading_line == 0
    return
  endif

  " Find the next heading after cursor (don't move cursor)
  let next_heading = search('^#\+ ', 'nW')

  " End line: one before next heading, or end of file
  if next_heading == 0
    let end_line = line('$')
  else
    let end_line = next_heading - 1
  endif

  " Strip trailing blank lines
  while end_line > heading_line && getline(end_line) =~ '^\s*$'
    let end_line -= 1
  endwhile

  if a:around
    let start_line = heading_line
  else
    " Skip the heading line and any blanks after it
    let start_line = heading_line + 1
    while start_line <= end_line && getline(start_line) =~ '^\s*$'
      let start_line += 1
    endwhile
  endif

  if start_line > end_line
    return
  endif

  call setpos("'<", [0, start_line, 1, 0])
  call setpos("'>", [0, end_line, col([end_line, '$']), 0])
  normal! gv
endfunction


onoremap <buffer> hh :<C-u>call <SID>MarkdownHeadingObject(0)<CR>
onoremap <buffer> ah :<C-u>call <SID>MarkdownHeadingObject(1)<CR>
xnoremap <buffer> hh :<C-u>call <SID>MarkdownHeadingObject(0)<CR>
xnoremap <buffer> ah :<C-u>call <SID>MarkdownHeadingObject(1)<CR>
