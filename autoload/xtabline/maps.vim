function! xtabline#maps#init()

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Mappings
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    let X = g:xtabline_settings.map_prefix

    fun! s:mapkeys(keys, plug)
        if maparg(a:keys) == '' && !hasmapto(a:plug)
            silent! execute 'nmap <unique> '.a:keys.' '.a:plug
        endif
    endfun

    call s:mapkeys('<F5>',         '<Plug>(XT-Toggle-Tabs)')
    call s:mapkeys('<leader><F5>', '<Plug>(XT-Toggle-Filtering)')
    call s:mapkeys('<leader>b',    '<Plug>(XT-Select-Buffer)')
    call s:mapkeys(']b',           '<Plug>(XT-Next-Buffer)')
    call s:mapkeys('[b',           '<Plug>(XT-Prev-Buffer)')
    call s:mapkeys(X.'q',          '<Plug>(XT-Close-Buffer)')
    call s:mapkeys(X.'b',          '<Plug>(XT-Open-Buffers)')
    call s:mapkeys(X.'db',         '<Plug>(XT-Delete-Buffers)')
    call s:mapkeys(X.'dB',         '<Plug>(XT-Delete-Global-Buffers)')
    call s:mapkeys(X.'lt',         '<Plug>(XT-Load-Tab)')
    call s:mapkeys(X.'st',         '<Plug>(XT-Save-Tab)')
    call s:mapkeys(X.'dt',         '<Plug>(XT-Delete-Tab)')
    call s:mapkeys(X.'ls',         '<Plug>(XT-Load-Session)')
    call s:mapkeys(X.'ss',         '<Plug>(XT-Save-Session)')
    call s:mapkeys(X.'ds',         '<Plug>(XT-Delete-Session)')
    call s:mapkeys(X.'p',          '<Plug>(XT-Purge)')
    call s:mapkeys(X.'C',          '<Plug>(XT-Wipe)')
    call s:mapkeys(X.'c',          '<Plug>(XT-Clean-Up)')
    call s:mapkeys(X.'r',          '<Plug>(XT-Reopen)')
    call s:mapkeys(X.'f',          '<Plug>(XT-Set-Depth)')
    call s:mapkeys(X.'tt',         '<Plug>(XT-Tab-Todo)')
    call s:mapkeys(X.'trp',        '<Plug>(XT-Relative-Paths)')
    call s:mapkeys(X.'cdc',        '<Plug>(XT-Cd-Current)')
    call s:mapkeys(X.'cdd',        '<Plug>(XT-Cd-Down)')
    call s:mapkeys(X.'cdr',        '<Plug>(XT-Reset)')
    if exists('g:loaded_leaderGuide_vim')
        call s:mapkeys(X, '<Plug>(XT-Leader-Guide)')
    endif

    nnoremap <unique> <silent>        <Plug>(XT-Toggle-Tabs)           :<c-u>call xtabline#cmds#run('toggle_tabs')<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Toggle-Filtering)      :<c-u>call xtabline#cmds#run('toggle_buffers')<cr>
    nnoremap <unique> <silent> <expr> <Plug>(XT-Select-Buffer)         g:xtabline.Vars.changing_buffer ? "\<C-c>" : ":<C-u>call xtabline#select_buffer(v:count)\<cr>"
    nnoremap <unique> <silent> <expr> <Plug>(XT-Next-Buffer)           xtabline#next_buffer(v:count1)
    nnoremap <unique> <silent> <expr> <Plug>(XT-Prev-Buffer)           xtabline#prev_buffer(v:count1)
    nnoremap <unique> <silent>        <Plug>(XT-Close-Buffer)          :<c-u>XTabCloseBuffer<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Open-Buffers)          :<c-u>XTabOpenBuffers<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Delete-Buffers)        :<c-u>XTabDeleteBuffers<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Delete-Global-Buffers) :<c-u>XTabDeleteGlobalBuffers<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Load-Tab)              :<c-u>XTabLoadTab<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Save-Tab)              :<c-u>XTabSaveTab<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Delete-Tab)            :<c-u>XTabDeleteTab<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Load-Session)          :<c-u>XTabLoadSession<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Save-Session)          :<c-u>XTabSaveSession<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Delete-Session)        :<c-u>XTabDeleteSession<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Purge)                 :<c-u>XTabPurge<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Wipe)                  :<c-u>XTabCleanUp<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Clean-Up)              :<c-u>XTabCleanUp!<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Reopen)                :<c-u>XTabReopen<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Set-Depth)             :<c-u>call xtabline#cmds#run('depth', v:count)<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Tab-Todo)              :<c-u>XTabTodo<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Cd-Current)            :<c-u>call <sid>cd(0)<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Cd-Down)               :<c-u>call <sid>cd(v:count1)<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Reset)                 :<c-u>XTabReset<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Relative-Paths)        :<c-u>XTabRelativePaths<cr>
    nnoremap <unique> <silent>        <Plug>(XT-Leader-Guide)          :<c-u>silent! LeaderGuideD g:xtabline.leader_guide<cr>

    let g:xtabline.leader_guide = {
            \'q':   ["XTabCloseBuffer",                    "Close Buffer"            ],
            \'b':   ["XTabOpenBuffers",                    "Open Buffer(s)"          ],
            \'db':  ["XTabDeleteBuffers",                  "Delete Tab Buffer(s)"    ],
            \'dB':  ["XTabDeleteGlobalBuffers",            "Delete Global Buffer(s)" ],
            \'lt':  ["XTabLoadTab",                        "Load Tab Bookmark(s)"    ],
            \'st':  ["XTabSaveTab",                        "Save Tab Bookmark(s)"    ],
            \'dt':  ["XTabDeleteTab",                      "Delete Tab Bookmark(s)"  ],
            \'ls':  ["XTabLoadSession",                    "Load Session"            ],
            \'ss':  ["XTabSaveSession",                    "Save Session"            ],
            \'ds':  ["XTabDeleteSession",                  "Delete Session"          ],
            \'p':   ["XTabPurge",                          "Purge"                   ],
            \'C':   ["XTabCleanUp",                        "Clean Up Tabs"           ],
            \'c':   ["XTabCleanUp!",                       "Clean Up Tabs!"          ],
            \'r':   ["XTabReopen",                         "Reopen Tab"              ],
            \'f':   ["call xtabline#cmds#run('depth', 0)", "Toggle Tab Filtering"    ],
            \'tt':  ["XTabTodo",                           "Tab Todo"                ],
            \'trp': ["XTabRelativePaths",                  "Toggle Relative Paths"   ],
            \}

endfunction

fun! s:cd(count)
    let path = ':p:h'
    for c in range(a:count)
        let path .= ':h'
    endfor
    let cwd = fnamemodify(expand("%", ":p"), path)
    cd `=cwd`
    let g:xtabline.Tabs[tabpagenr()-1].cwd = cwd
    doautocmd BufAdd
    call xtabline#update_obsession()
    pwd
endfun

