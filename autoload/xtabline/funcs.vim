fun! xtabline#funcs#init() abort
  let s:X = g:xtabline
  let s:v = s:X.Vars
  let s:Sets = g:xtabline_settings

  let s:T =  { -> s:X.Tabs[tabpagenr()-1] }       "current tab
  let s:vB = { -> s:T().buffers.valid     }       "valid buffers for tab
  let s:oB = { -> s:T().buffers.order     }       "ordered buffers for tab
  return xtabline#dir#init(s:Funcs)
endfun

let s:Funcs = {}

let s:Funcs.wins    = {   -> tabpagebuflist(tabpagenr()) }
let s:Funcs.has_win = { b -> index(s:Funcs.wins(), b) >= 0 }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc functions                                                           {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:Funcs.delay(time, func) abort "{{{2
  " Call a function with a timer

  " if exists('g:SessionLoad') || s:v.halt | return | endif
  let s:delayed_func = a:func
  call timer_start(a:time, self._delay)
endfun

fun! s:Funcs._delay(timer) abort
  exe "call" s:delayed_func
endfun


fun! s:Funcs.input(prompt, ...) abort "{{{2
  " Input with colored prompt.

  echohl Label
  let [ text, complete ] = a:0 ? [ a:1, a:2 ] : [ '', '' ]
  let i = input(a:prompt, text, complete)
  echohl None
  return i
endfun


fun! s:Funcs.msg(txt, ...) abort "{{{2
  " Print a message with highlighting

  redraw
  if type(a:txt) == v:t_string
    exe "echohl" a:0 && a:1? "WarningMsg" : "Label"
    echon a:txt | echohl None
    return
  endif

  for txt in a:txt
    exe "echohl ".txt[1]
    echon txt[0]
    echohl None
  endfor
endfun



fun! s:Funcs.set_buffer_var(var, ...) abort "{{{2
  " Init buffer variable in Tabs dict to 0 or a given value.
  " Return buffer dict if successful

  let B = bufnr('%') | let bufs = s:X.Buffers | let val = a:0 ? a:1 : 0

  if !self.is_tab_buffer(B)
    return self.msg ([[ "Invalid buffer.", 'WarningMsg']]) | endif

  if has_key(bufs, B) | let bufs[B][a:var] = val
  else                | let bufs[B] = {a:var: val, 'path': expand("%:p")}
  endif
  return bufs[B]
endfun



fun! s:Funcs.fullpath(path, ...) abort "{{{2
  " OS-specific modified path

  let path = expand(a:path)
  let path = empty(path) ? a:path : path        "expand can fail
  let mod = a:0 ? a:1 : ":p"
  let path = s:v.winOS ?
        \tr(fnamemodify(path, mod), '\', '/') : fnamemodify(path, mod)
  return resolve(path)
endfun



fun! s:Funcs.sep() abort "{{{2
  " OS-specific directory separator

  return s:v.winOS ? '\' : '/'
endfun



fun! s:Funcs.todo_path() abort "{{{2
  return fnameescape(getcwd().self.sep().s:Sets.todo.file)
endfun



fun! s:Funcs.tab_buffers() abort   "{{{2
  " Return a list of buffers names for this tab

  return map(copy(s:vB()), 'bufname(v:val)')
endfun



fun! s:Funcs.add_ordered(buf, ...) abort "{{{2
  " Add a buffer to the Tab.buffers.order list.

  let [ b, bufs, first, i ] = [ a:buf, s:oB(), a:0, index(s:oB(), a:buf) ]

  " if the buffer goes first, remove it from the list if present
  if i >= 0 && first | call remove(bufs, i) | endif

  " if the buffer doesn't go first, only add it if not present
  if first      | call insert(bufs, b, 0)
  elseif i < 0  | call add(bufs, b)
  endif
endfun



fun! s:Funcs.uniq(list) abort "{{{2
  " Make sure an element appears only once in the list.

  let [ i, max ] = [ 0, len(a:list)-2 ]
  while i <= max
    let extra = index(a:list, a:list[i], i+1)
    if extra > 0
      call remove(a:list, extra)
      let max -= 1
    else
      let i += 1
    endif
  endwhile
  return a:list
endfun



fun! s:Funcs.is_tab_buffer(...) abort "{{{2
  " Verify that the buffer belongs to the tab

  return (index(s:vB(), a:1) != -1)
endfun



fun! s:Funcs.all_valid_buffers(...) abort "{{{2
  " Return all valid buffers for all tabs

  let valid = []
  for i in range(tabpagenr('$'))
    if a:0
      call extend(valid, s:X.Tabs[i].buffers.order)
    else
      call extend(valid, s:X.Tabs[i].buffers.valid)
    endif
  endfor
  return valid
endfun



fun! s:Funcs.all_open_buffers() abort "{{{2
  " Return all open buffers for all tabs

  let open = []
  for i in range(tabpagenr('$')) | call extend(open, tabpagebuflist(i + 1)) | endfor
  return open
endfun "}}}




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortened paths                                                          {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:Funcs.short_cwd(tabnr, h, ...) abort "{{{2
  let path = a:0 ? a:1 : getcwd()

  if !a:h
    return fnamemodify(path, ":t")
  else
    let H = fnamemodify(path, ":~")
    if s:v.winOS | let H = tr(H, '\', '/')
  endif

  let splits = split(H, '/')
  if len(splits) > a:h
    let [ head, tail ] = [splits[:-(a:h+1)], splits[-(a:h):]]
    call map(head, "substitute(v:val, '\\(.\\).*', '\\1', '')")
    let H = join(head + tail, '/')
  endif
  if s:v.winOS
    let H = tr(H, '/', '\')
  endif
  return H
endfun



fun! s:Funcs.short_path(bnr, h) abort "{{{2
  if !filereadable(bufname(a:bnr))
    let bname = bufname(a:bnr)
    return empty(bname) && &buftype != ''
          \ ? '[Volatile]'
          \ : empty(bname) ? '...' : bname
  endif

  let H = fnamemodify(bufname(a:bnr), ":~:.")

  if !a:h | return fnamemodify(path, ":t")       | endif
  if empty(bufname(H)) | return ''               | endif
  if s:v.winOS         | let H = tr(H, '\', '/') | endif
  if match(H, '/') < 0 | return H                | endif

  let is_root = H[:0] == '/'
  let splits  = split(H, '/')
  let h       = min([len(splits), abs(a:h)])

  if a:h < 0
    let head = split(fnamemodify(bufname(a:bnr), ":~:h"), '/')
    let tail = [fnamemodify(bufname(a:bnr), ":t")]
    return join(head[-h:] + tail, '/')
  else
    let head = splits[:-(h+1)]
    let tail = splits[-h:]
  endif
  call map(head, "substitute(v:val, '\\(.\\).*', '\\1', '')")
  let H = join(head + tail, '/')
  if is_root
    let H = '/' . H
  elseif s:v.winOS
    let H = tr(H, '/', '\')
  endif
  return H
endfun



fun! s:Funcs.bdelete(buf) abort "{{{2
  " Delete buffer if unmodified and not pinned

  if index(s:X.pinned_buffers, a:buf) >= 0
    call self.msg("Pinned buffer has not been deleted.", 1)

  elseif s:T().locked && index(s:T().buffers.valid, a:buf) >= 0
    call remove(s:T().buffers.valid, index(s:T().buffers.valid, a:buf))

  elseif getbufvar(a:buf, '&ft') == 'nofile'
    exe "silent! bwipe ".a:buf
    call xtabline#update()

  elseif !getbufvar(a:buf, '&modified')
    exe "silent! bdelete ".a:buf
    call xtabline#update()
  endif
endfun



fun! s:Funcs.not_enough_buffers(pinned) abort "{{{2
  " Just return if there aren't enough buffers

  let bufs = a:pinned ? s:v.pinned_buffers : s:oB()
  let pin  = a:pinned ? ' pinned ' : ' '

  if len(bufs) < 2
    if empty(bufs)
      call self.msg ([[ "No available".pin."buffers for this tab.", 'WarningMsg' ]])
    elseif index(bufs, bufnr("%")) == -1
      return
    else
      call self.msg ([[ "No other available".pin."buffers for this tab.", 'WarningMsg' ]])
    endif
    return 1
  endif
endfun "}}}




