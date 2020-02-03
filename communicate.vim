function! NeovimOutHandler(job_id, data, event) abort
   echom string([a:job_id, a:data, a:event])
  let messages = a:data[:-2]

  if exists('g:job')
    if len(a:data) > 1
      let messages[0] = g:job.partial . messages[0]
      let g:job.partial = a:data[-1]
    else
      let g:job.partial = g:job.partial . a:data[0]
    endif
  endif

  for message in messages
    if message =~# "^\uFEFF"
      " Strip BOM
      let message = substitute(message, "^\uFEFF", '', '')
    endif
    echohl Identifier | echom message | echohl None
  endfor
endfunction

function! NeovimJobStart() abort
  let opts = {
  \ 'on_stdout': 'NeovimOutHandler'
  \}
  let g:job = {
  \ 'job_id': jobstart(['cmd.exe', '/c', 'C:\code\test\frameworkApp\bin\Debug\simpleio.exe'], opts),
  \ 'partial': ''
  \}
endfunction


function! VimOutHandler(channel, message) abort
  echohl Identifier | echom a:message | echohl None
endfunction

function! VimJobStart() abort
  let opts = { 'out_cb': 'VimOutHandler' }
  let g:job = {
  \ 'job_id': job_start('bin\Debug\simpleio.exe', opts)
  \}
endfunction


function! SendMessage(message) abort
  if has('nvim')
    echom 'sent ' . chansend(g:job.job_id, [a:message, ""]) . ' bytes'
  else
    call ch_sendraw(g:job.job_id, a:message . "\n")
  endif
endfunction
command! -nargs=+ SendMessage call SendMessage(<q-args>)

function! StartServer() abort
  if exists('g:job')
    echo 'A server is already running'
    return
  endif
  if has('nvim')
    echom 'Starting for Neovim'
    call NeovimJobStart()
  else
    echom 'Starting for Vim'
    call VimJobStart()
  endif
endfunction
command! StartServer call StartServer()


function! StopServer() abort
  if !exists('g:job')
    echo 'No server running'
    return
  endif
  if has('nvim')
    call jobstop(g:job.job_id)
  else
    call job_stop(g:job.job_id)
  endif
  unlet g:job
  echom 'Server stopped'
endfunction
command! StopServer call StopServer()
