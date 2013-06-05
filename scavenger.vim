" This plugin searches for all files, specified by g:scavenger_patterns, up the
" path and sources them all, starting from the outermost.
"
" Copyright bijoutrouvaille at gmail dot com 2013
" Licence propagated from rooter.vim, of which some code was used initially,
" later to be heavily modified. There for it is...
" Licenced under MIT licence

if !exists("g:loaded_scavenger")
  let g:loaded_scavenger = 1
else 
  " finish
endif 

if !exists('g:scavenger_patterns')
  " a list of glob patterns
  let g:scavenger_patterns = ['project.vim', 'rc.vim'] 
endif
if !exists('g:scavenger_exclude')
  " a regular expression list
  let g:scavenger_exclude = [] 
endif

if !exists('g:scavenger_manual_only')
  " prevent from setting up an autocmd
  let g:scavenger_manual_only = 0
endif

if !exists( 'g:scavenger_viewer_line_marker' )
	" 
	let g:scavenger_viewer_line_marker = ">" 
endif
"
" A wrapepr for the recursive function that searches up the path to find all occurrences of
" project files. This function provides the default starting conditions of an
" empty file list and the directory of the current file, or if the buffer is
" unsaved then current working directory.
"
function! s:FindRcFiles()
  return s:RFindRcFiles("", [])
endfunction

function! s:RFindRcFiles(dir, rcFiles)

  let l:rcFiles = copy(a:rcFiles)
  let l:dir = a:dir
  if empty(l:dir)
    " use pwd for the current root if in a virtual file system or if editing
    " a buffer without a file name.
    if (match(expand('%:p'), '^\w\+://.*') != -1)
      return l:rcFiles
    elseif empty(expand("%"))
      let l:dir = getcwd()
    else 
      let l:dir = fnameescape(expand("%:p:h"))
    endif
  endif
    
  for pattern in g:scavenger_patterns
    " prepend new files to the beginning of the list, so that outer files
    " are executed first
    call extend(l:rcFiles, s:FilterRcList(split(globpath(l:dir, pattern, 1), "\n")), 0)
  endfor

  if l:dir == "/"
    return l:rcFiles
  else 
    return s:RFindRcFiles(fnamemodify(expand(l:dir),":h"), l:rcFiles)
  endif

endfunction

function! s:FilterRcList(rcFiles)
  return filter(copy(a:rcFiles), "!s:IsExcluded(v:val)")
endfunction

function! s:IsExcluded(path)

  let l:path = fnamemodify(a:path,":p")
  if  l:path==expand("%:p")
    return 1
  endif
  for pattern in g:scavenger_exclude
    if match(l:path, pattern)
      return 1
    endif
  endfor
  return 0
endfunction

function! s:SourceRcFiles()
  let l:fs = s:FindRcFiles()
  for rcfile in l:fs
    if filereadable(rcfile)
      exe ":source " . rcfile
    endif
  endfor
endfunction

function! s:ShowCtrlPList(fileList)
endfunction

function! s:Highlight(lineNumber)
  exe printf('match %s /^%s\%%%dl/',
    \ "ScavengerSelection", 
    \ g:scavenger_viewer_line_marker,
    \ a:lineNumber)
  exe printf("normal! %dgg", a:lineNumber)
  redraw
endfunction

function! s:ActivateListInputLoop(totalLineCount)

  highlight default ScavengerSelection cterm=reverse gui=reverse term=reverse
  let l:line = 1
  call s:Highlight(l:line)

	while 1
    let l:charnr = getchar()
		let l:char = nr2char(l:charnr)
		if l:char == "\<Esc>" || l:char == "q"
			bd!	

			break
		elseif l:char == "\<CR>"
			let l:file = fnameescape(substitute(
				\ getline(l:line), 
				\ '^'.g:scavenger_viewer_line_marker.' ',
				\ '',""))

			if !empty(l:file) && filereadable(l:file)
        let l:buf = bufnr("%")
				exe "tabe " . l:file
				exe "bd! ".l:buf
			endif

			break
		elseif l:charnr == "\<Down>" || l:char=='j'
      if l:line == a:totalLineCount
        let l:line = 1
      else 
        let l:line += 1
      endif

      call s:Highlight(l:line)
      redraw
		elseif l:charnr == "\<Up>" || l:char=="k"
      if l:line==1
        let l:line = a:totalLineCount
      else 
        let l:line -= 1
      endif
      call s:Highlight(l:line)
		endif

	endwhile	

endfunction

function! s:ShowVanillaList(fileList)
	
  let l:fs = a:fileList
  let l:fileCount = len(l:fs)

  if l:fileCount==0
    echom "There are no resource files in this tree"
    return
  endif

  exe printf("bo %dnew", min([7, l:fileCount + 1]))
  let l:stline = escape(printf('Total resource files in tree: %d. Press return to open, esc to cancel.', len(l:fs)),'"\ ')
	exe 'setlocal statusline=%{\"'. l:stline .'\"}'
  setlocal nonumber

  let l:i=0	
  for rcfile in l:fs
	  if filereadable(rcfile)
		  
		  if i==0
			  let l:insertEffectuator="i"
		  else
			  let l:insertEffectuator="o"
		  endif

		  exe printf("normal!%s%s %s", l:insertEffectuator, g:scavenger_viewer_line_marker, rcfile)
		  let l:i += 1
	  endif
  endfor

  redraw
  setlocal nomodifiable
  setlocal cursorline
  call s:ActivateListInputLoop(l:fileCount)


endfunction

function! s:ViewRcFiles()
  let l:fs = s:FindRcFiles()
	call s:ShowVanillaList(l:fs)
endfunction

  
command! Scavange :call <SID>SourceRcFiles()
command! ScaFiles :call <SID>ViewRcFiles()

if !g:scavenger_manual_only
  augroup scavenger
    autocmd!
    autocmd BufEnter * :Scavange
  augroup END
endif
