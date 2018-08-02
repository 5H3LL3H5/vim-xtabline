""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:X    = g:xtabline
let s:F    = s:X.Funcs
let s:V    = s:X.Vars
let s:Sets = g:xtabline_settings

let s:T    =  { -> s:X.Tabs[tabpagenr()-1] }       "current tab
let s:B    =  { -> s:X.Buffers             }       "customized buffers
let s:vB   =  { -> s:T().buffers.valid     }       "valid buffers for tab
let s:oB   =  { -> s:T().buffers.order     }       "ordered buffers for tab

let s:scratch =  { nr -> index(['nofile','acwrite','help'], getbufvar(nr, '&buftype')) >= 0 }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! xtabline#cmds#run(cmd, ...)
  let args = !a:0? '' : a:0==1? string(a:1) : string(a:000)
  exe "call s:".a:cmd."(".args.")"
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:toggle_tabs()
  """Toggle between tabs/buffers tabline."""

  if tabpagenr("$") == 1 | echo "There is only one tab." | return | endif

  if s:V.showing_tabs
    let s:V.showing_tabs = 0
    call s:F.msg ([[ "Showing buffers", 'StorageClass' ]])
  else
    let s:V.showing_tabs = 1
    call s:F.msg ([[ "Showing tabs", 'StorageClass' ]])
  endif

  if !s:plugins_toggle_tabs() | call xtabline#filter_buffers() | endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:toggle_buffers()
  """Toggle buffer filtering in the tabline."""

  if s:V.filtering
    let g:airline#extensions#tabline#exclude_buffers = []
    call s:F.msg ([[ "Buffer filtering turned off", 'WarningMsg' ]])
  else
    call s:F.msg ([[ "Buffer filtering turned on", 'StorageClass' ]])
  endif
  let s:V.filtering = !s:V.filtering
  if !s:plugins_toggle_buffers() | call xtabline#filter_buffers() | endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:depth(args)
  """Set tab filtering depth, toggle filtering with bang."""
  let [bang, cnt] = a:args | let T = s:T()
  let cnt = (bang && T.depth == -1)? 0 :
          \ bang? -1 :
          \ !cnt && !T.depth? -1 : cnt
  let T.depth = cnt
  call xtabline#filter_buffers()

  let n = cnt < 2? 0 : cnt-1
  let tree = !executable('tree')? ['', 'None'] : !n? ['', 'None'] :
              \ ["\n\n".system('tree -d -L '.n.' '.getcwd()), 'Type']

  if cnt < 0
    call s:F.msg ([[ "Buffer filtering is now disabled.", 'WarningMsg']])

  elseif !cnt
    call s:F.msg ([[ "Buffer filtering is now unrestricted to ", 'Type'],
                  \[ getcwd(), 'None'],
                  \[ " and all subdirectories", 'Type']])
  else
    call s:F.msg ([[ "Buffer filtering is now restricted to ", 'WarningMsg'],
                  \[ cnt-1, 'None'],
                  \[ " directories below ", 'WarningMsg'],
                  \[ getcwd(), 'None' ], tree])
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:purge_buffers()
  """Remove unmodified buffers with invalid paths."""

  if s:T().depth < 0 || !s:V.filtering | echo "Buffer filtering is turned off." | return | endif
  let bcnt = 0 | let bufs = [] | let purged = [] | let accepted = s:vB()

  " include previews if not showing in tabline
  for buf in tabpagebuflist(tabpagenr())
    if index(accepted, buf) == -1 | call add(bufs, buf) | endif
  endfor

  " purge the buffer if:
  " 1. non-existant path and file unmodified
  " 2. path doesn't belong to cwd, but it has been accepted for partial match

  for buf in (accepted + bufs)
    let bufpath = fnamemodify(bufname(buf), ":p")

    if !filereadable(bufpath)
      if !getbufvar(buf, "&modified")
        let bcnt += 1 | let ix = index(accepted, buf)
        if ix >= 0 | call add(purged, remove(accepted, ix))
        else | call add(purged, buf) | endif
      endif

    elseif bufpath !~ "^".s:T().cwd
      let bcnt += 1 | let ix = index(accepted, buf)
      if ix >= 0 | call add(purged, remove(accepted, ix))
      else | call add(purged, buf) | endif
    endif
  endfor

  " the tab may be closed if there is one window, and it's going to be purged
  if len(tabpagebuflist()) == 1 && !empty(accepted) && index(purged, bufnr("%")) >= 0
    execute "buffer ".accepted[0] | endif

  for buf in purged | execute "silent! bdelete ".buf | endfor

  call xtabline#filter_buffers()
  let s = "Purged ".bcnt." buffer" | let s .= bcnt!=1 ? "s." : "." | echo s
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:clean_up(...)
  """Remove all invalid/not open(!) buffers in all tabs.
  let valid  = s:F.all_valid_buffers()
  let active = s:F.all_open_buffers()
  let ok     = !a:1? valid + active : active

  let nr = 0
  for b in range(1, bufnr('$'))
    if !buflisted(b) && !s:scratch(b) | continue | endif
    if index(ok, b) == -1
      execute "silent! bdelete ".string(b)
      let nr += 1
    endif
  endfor

  let s = "Cleaned ".nr." buffer" | let s .= nr!=1 ? "s." : "."
  call s:F.msg([[s, 'WarningMsg']])
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:reopen_last_tab()
  """Reopen the last closed tab."""

  if !exists('g:xtabline.Vars.most_recently_closed_tab')
    call s:F.msg("No recent tabs.", 1) | return | endif

  tabnew
  let empty = bufnr("%")
  let tab = xtabline#new_tab(s:V.most_recently_closed_tab)
  cd `=tab.cwd`
  call xtabline#filter_buffers()
  execute "b ".s:oB()[0]
  execute "bdelete ".empty
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:close_buffer()
  """Close and delete a buffer, without closing the tab."""
  let current = bufnr("%") | let alt = bufnr("#") | let tbufs = len(s:vB())

  if buflisted(alt) && s:F.is_tab_buffer(alt)
    execute "buffer #" | call s:F.bdelete(current)

  elseif ( tbufs > 1 ) || ( tbufs && !s:F.is_tab_buffer(current) )
    execute "normal \<Plug>XTablinePrevBuffer" | call s:F.bdelete(current)

  elseif !s:Sets.close_buffer_can_close_tab
    echo "Last buffer for this tab."
    return

  elseif getbufvar(current, '&modified')
    call s:F.msg("Not closing because of unsaved changes", 1)
    return

  elseif tabpagenr() > 1 || tabpagenr("$") != tabpagenr()
    tabnext | silent call s:F.bdelete(current)
  else
    quit | endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:relative_paths()
  """Toggle between full relative path and tail only, in the bufline.
  let s:V.buftail = !s:V.buftail
  call xtabline#filter_buffers()
  if s:V.buftail
    call s:F.msg ([[ "Buffers relative paths disabled.", 'WarningMsg']])
  else
    call s:F.msg ([[ "Buffers relative paths enabled.", 'StorageClass']])
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:tab_todo()
  """Open the Tab todo file.
  let todo = s:Sets.todo
  if todo['command'] == 'edit'
    execute "edit ".s:F.todo_path()
  else
    execute todo['prefix']." ".todo['size'].todo['command']." ".s:F.todo_path()
  endif
  execute "setlocal syntax=".todo['syntax']
  nmap <silent><nowait> <buffer> q :w<bar>bdelete<cr>
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:rename_tab(label)
  """Rename the current tab.
  let s:X.Tabs[tabpagenr()-1].name = a:label
  call xtabline#filter_buffers()
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:rename_buffer(label)
  """Rename the current buffer.
  let B = s:F.set_buffer_var('name', a:label)
  if empty(B) | return | endif
  call xtabline#filter_buffers()
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:get_icon(ico)
  """Get current icon for this tab."""
  let I = get(s:Sets, 'custom_icons', {})
  if index(keys(I), a:ico) >= 0
    return I[a:ico]
  elseif strchars(a:ico) == 1
    return a:ico
  else
    call s:F.msg ([[ "Invalid icon.", 'WarningMsg']])
    return
  endif
endfun

fun! s:tab_icon(...)
  """Set an icon for this tab."""
  let [bang, icon] = a:1
  let T = s:T()
  if bang
    let T.icon = ''
  else
    let icon = s:get_icon(icon)
    if !empty(icon)
      let T = s:T()
      let T.icon = icon
    endif
  endif
  call xtabline#filter_buffers()
endfun

fun! s:buffer_icon(...)
  """Set an icon for this buffer."""
  let [bang, icon] = a:1
  let B = s:F.set_buffer_var('icon')
  if empty(B) | return | endif

  if bang
    let B.icon = ''
  else
    let icon = s:get_icon(icon)
    if !empty(icon)
      let B.icon = icon
    endif
  endif
  call xtabline#filter_buffers()
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:toggle_pin_buffer(...)
  """Pin this buffer, so that it will be shown in all tabs. Optionally rename."""
  if a:0 && match(a:1, "\S") >= 0
    if empty(s:F.set_buffer_var('name', a:1)) | return | endif
  elseif !s:F.is_tab_buffer(bufnr('%'))
    call s:F.msg ([[ "Invalid buffer.", 'WarningMsg']]) | return
  endif

  let B = bufnr('%')
  let i = index(s:X.pinned_buffers, B)
  if i >= 0
    call remove(s:X.pinned_buffers, i)
  else
    call add(s:X.pinned_buffers, B)
  endif
  call xtabline#filter_buffers()
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:new_tab(...)
  """Open a new tab with optional name. CWD is $HOME.
  $tabnew
  let s:V.tab_properties = {'name': a:0? a:1 : '', 'cwd': expand("~")}
  call add(s:X.Tabs, s:F.new_tab())
  call xtabline#filter_buffers()
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:format_buffer()
    """Specify a custom format for this buffer."""
    let och = &ch
    set ch=2

    let n = bufnr("%")
    if !s:F.is_tab_buffer(n)
      call s:F.msg ([[ "Invalid buffer.", 'WarningMsg']]) | return | endif

    let has_format = has_key(s:B(), n) && has_key(s:B()[n], 'format')
    let current = has_format? s:B()[n].format : s:Sets.bufline_format
    echohl Label | echo "Current  │" | echohl Special | echon current | echohl Label

    let new = input("New      │", current) | echohl None
    if !empty(new) | call s:F.set_buffer_var('format', new)
    else           | call s:F.msg ([[ "Canceled.", 'WarningMsg' ]])
    endif

    let &ch = och
    call xtabline#filter_buffers()
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:set_cwd(...)
  """Set new working directory."""
  let [bang, cwd] = a:1
  let cwd = expand(cwd, ":p")

  if !bang && empty(cwd)
    call s:F.msg ([[ "Canceled.", 'WarningMsg' ]]) | return
  elseif bang
    let home = expand("~", ":p") | echohl Label
    let cwd = input("Enter a new working directory: ", home, "file") | echohl None
  endif

  if !isdirectory(cwd)
    call s:F.msg ([[ "Wrong directory.", 'WarningMsg' ]])
  else
    cd `=cwd`
    redraw!
    call s:F.msg ([[ "New working directory set: ", 'Label' ], [ cwd, 'None' ]])
    let s:X.Tabs[tabpagenr()-1].cwd = cwd
    call xtabline#filter_buffers()
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:reset_tab(...)
  "Reset the tab to a pristine state.
  let s:X.Tabs[tabpagenr()-1] = xtabline#new_tab({'cwd': a:0? expand(a:1) : expand("~")})
  call xtabline#filter_buffers()
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adjustments for Airline or other plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:plugins_toggle_tabs()
  if exists('g:loaded_airline')
    let g:airline#extensions#tabline#show_tabs = s:V.showing_tabs
    AirlineRefresh
    doautocmd BufAdd
    return 1
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:plugins_toggle_buffers()
  if exists('g:loaded_airline') && !s:V.filtering
    let g:airline#extensions#tabline#exclude_buffers = []
    doautocmd BufAdd
    return 1
  endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
