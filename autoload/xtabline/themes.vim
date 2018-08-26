let s:yelw1 = '#DADA93' | let s:yelw2 = '#F2C38F' | let s:lblu1 = '#97BEEF' | let s:lblu2 = '#83AFE5'
let s:blue1 = '#569cd6' | let s:blue2 = '#3A7CB2' | let s:blue3 = '#264F78' | let s:blue4 = '#244756'
let s:dblu1 = '#073655' | let s:dblu2 = '#212733' | let s:gren1 = '#A8CE93' | let s:gren2 = '#608b4e'
let s:cyan1 = '#7FC1CA' | let s:cyan2 = '#42DCD7' | let s:purpl = '#9A93E1' | let s:pink1 = '#dfafdf'
let s:pink2 = '#D18EC2' | let s:pink3 = '#C586C0' | let s:grey1 = '#556873' | let s:grey2 = '#4C4E50'
let s:grey3 = '#3C4C55' | let s:dgrey = '#3D3D40' | let s:lgry1 = '#C5D4DD' | let s:lgry2 = '#c9c6c9'
let s:lgry3 = '#a9a9a9' | let s:lgry4 = '#9a9a9a' | let s:blugr = '#6A7D89' | let s:clay1 = '#ce9178'
let s:redli = '#DF8C8C' | let s:redbr = '#ff0000' | let s:reddk = '#bf3434' | let s:whit1 = '#F9F9FF'
let s:whit2 = '#E6EEF3' | let s:blak1 = '#333233' | let s:blak2 = '#262626' | let s:blak3 = '#1e1e1e'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:black    = '#282a36' "235
let s:gray     = '#44475a' "236
let s:white    = '#f8f8f2' "231
let s:darkblue = '#6272a4' "61
let s:cyan     = '#8be9fd' "117
let s:green    = '#50fa7b' "84
let s:orange   = '#ffb86c' "215
let s:purple   = '#bd93f9' "141
let s:red      = '#ff79c6' "212
let s:yellow   = '#f1fa8c' "228

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'highlight_group': [ ctermfg, ctermbg, guifg, guibg, style ]
" style: 0=NONE, 1=bold, 2=italic, 3=underline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:Themes = {}

let s:fill_dark = [ 248, 233, s:lgry3,   "#171717", 0 ]
let s:fill_lite = [ 231, 239, s:white,   "#616161", 0 ]
let s:bg     = { c1, c2 -> &background=='light' ? c1 : c2 }

let s:Themes.seoul = { -> {
      \'name': 'seoul',
      \'enable_extra_highlight': 1,
      \'basic': {
          \"XBufLineCurrent" : [ 187,  23, "#DFDEBD", "#007173", 1 ],
          \"XBufLineActive"  : [ 68,  233, s:yelw2,   "#171717", 0 ],
          \"XBufLineHidden"  : s:fill_lite,
          \"XBufLineFill"    : s:bg(s:fill_lite, s:fill_dark),
          \"XTabLineSelMod"  : [ 74,  237, s:lblu2,   s:grey3,   0 ],
          \"XTabLineSel"     : [ 187, 237, "#DFDEBD", s:grey3,   1 ],
          \"XTabLineMod"     : [ 248, 233, s:lgry3,   "#171717", 0 ],
          \"XTabLine"        : s:fill_lite,
          \"XTabLineFill"    : s:bg(s:fill_lite, s:fill_dark),
          \"XTabLineNumSel"  : [ 237, 150, s:grey3,   s:gren1,   0 ],
          \"XTabLineNum"     : [ 180, 233, s:yelw2,   "#171717", 0 ]},
      \'extra': {
          \"XBufLineSpecial" : [ 237, 150, s:grey3,   s:yelw2,   1 ],
          \"XBufLineMod"     : [ 203, 239, s:redli,   "#616161", 0 ],
          \"XBufLineModSel"  : [ 203, 23,  s:redli,   "#007173", 1 ],
          \"XBufLineModAct"  : [ 203, 23,  s:redli,   "#171717", 1 ],
          \"XBufLinePinned"  : [ 252, 89,  "#D9D9D9", "#9B1D72", 1 ]}
      \} }


let s:tm_dark = [ 248, 233, "#666666",   "#2d2d2d", 0 ]
let s:tm_lite = [ 231, 239, "#cccccc",   "#666666", 0 ]

let s:Themes.tomorrow = { -> {
      \'name': 'tomorrow',
      \'enable_extra_highlight': 1,
      \'basic': {
          \"XBufLineCurrent" : [ 187,  23, s:blak2, "#99cc99", 1 ],
          \"XBufLineActive"  : [ 68,  233, '#ffcc66',   "#444444", 0 ],
          \"XBufLineHidden"  : s:tm_lite,
          \"XBufLineFill"    : s:bg(s:tm_lite, s:tm_dark),
          \"XTabLineSelMod"  : [ 231, 239, '#f2777a',   "#666666", 1 ],
          \"XTabLineSel"     : s:tm_lite,
          \"XTabLineMod"     : [ 248, 233, s:lgry3,   "#2d2d2d", 0 ],
          \"XTabLine"        : [ 231, 239, "#cccccc",   "#444444", 0 ],
          \"XTabLineFill"    : s:bg(s:tm_lite, s:tm_dark),
          \"XTabLineNumSel"  : [ 237, 150, s:grey3,   s:gren1,   0 ],
          \"XTabLineNum"     : [ 180, 233, '#ffcc66',   "#444444", 0 ]},
      \'extra': {
          \"XBufLineSpecial" : [ 237, 150, s:grey3,   '#ffcc66',   1 ],
          \"XBufLineMod"     : [ 203, 239, '#f2777a',   "#616161", 0 ],
          \"XBufLineModSel"  : [ 203, 23,  '#f2777a',   "#99cc99", 1 ],
          \"XBufLineModAct"  : [ 203, 23,  '#f2777a',   "#444444", 1 ],
          \"XBufLinePinned"  : [ 252, 89,  s:blak2, "#cc99cc", 1 ]}
      \} }


let s:Themes.dracula = { -> {
      \'name': 'dracula',
      \'enable_extra_highlight': 1,
      \'basic': {
          \"XBufLineCurrent" : [ 231, 61,  s:white,  s:darkblue, 0 ],
          \"XBufLineActive"  : [ 117, 235, s:cyan,   s:black,    0 ],
          \"XBufLineHidden"  : [ 248, 236, s:lgry3,  s:gray,     0 ],
          \"XBufLineFill"    : s:bg(s:fill_lite, [ 248, 235, s:lgry3, s:black, 0 ]),
          \"XTabLineSelMod"  : [ 231, 61,  s:white,  s:darkblue, 0 ],
          \"XTabLineSel"     : [ 231, 61,  s:white,  s:darkblue, 0 ],
          \"XTabLineMod"     : [ 248, 236, s:lgry3,  s:gray,     0 ],
          \"XTabLine"        : [ 248, 236, s:lgry3,  s:gray,     0 ],
          \"XTabLineFill"    : s:bg(s:fill_lite, [ 248, 235, s:lgry3, s:black, 0 ]),
          \"XTabLineNumSel"  : [ 236, 84,  s:gray,   s:green,    0 ],
          \"XTabLineNum"     : [ 228, 235, s:yellow, s:black,    0 ]},
      \'extra': {
          \"XBufLineSpecial" : [ 236, 84,  s:gray,   s:green,    0 ],
          \"XBufLineMod"     : [ 212, 236,  s:red,   s:gray, 0 ],
          \"XBufLineModSel"  : [ 212, 61,  s:red,    s:darkblue, 1  ],
          \"XBufLineModAct"  : [ 212, 61,  s:red,    s:black, 1  ],
          \"XBufLinePinned"  : [ 141, 17,  s:purple, s:dblu1,    1 ]}
      \} }


let s:Themes.molokai = { -> {
      \'name': 'molokai',
      \'enable_extra_highlight': 1,
      \'basic': {
          \"XBufLineCurrent" : [ 234, 61,  '#f8f8f2',  '#ef5939' , 1 ],
          \"XBufLineActive"  : [ 81, 233, '#e6db74',   '#232526',    1 ],
          \"XBufLineHidden"  : [ 248, 17, s:lgry3,  s:dblu1,     0 ],
          \"XBufLineFill"    : s:bg(s:fill_lite, [ 248, 233, s:lgry3, '#232526', 0 ]),
          \"XTabLineSelMod"  : [ 160, 61,  '#ff0000',  '#ef5939', 0 ],
          \"XTabLineSel"     : [ 234, 61,  '#f8f8f2',  '#ef5939', 1 ],
          \"XTabLineMod"     : [ 248, 17, s:lgry3,  s:dblu1,     0 ],
          \"XTabLine"        : [ 248, 17, s:lgry3,  s:dblu1,     0 ],
          \"XTabLineFill"    : s:bg(s:fill_lite, [ 248, 233, s:dblu1, '#232526', 0 ]),
          \"XTabLineNumSel"  : [ 244, 84,  '#232526',   '#e6db74',    0 ],
          \"XTabLineNum"     : [ 229, 233, '#e6db74', '#232526',    0 ]},
      \'extra': {
          \"XBufLineSpecial" : [ 244, 84,  '#808080',   s:green,    0 ],
          \"XBufLineMod"     : [ 160, 244,  '#ff0000',   '#808080', 0 ],
          \"XBufLineModSel"  : [ 160, 61,  '#ff0000',    '#ef5939', 1  ],
          \"XBufLineModAct"  : [ 160, 61,  '#ff0000',    '#232526', 1  ],
          \"XBufLinePinned"  : [ 161, 17,  '#f92672', '#232526',    1 ]}
      \} }


let s:Themes.codedark = { -> {
      \'name': 'codedark',
      \'enable_extra_highlight': 1,
      \'basic': {
          \"XBufLineCurrent" : [ 237,  74, s:grey3, s:lblu2, 1 ],
          \"XBufLineActive"  : [ 68,  234, s:blue1, s:blak3, 1 ],
          \"XBufLineHidden"  : s:bg(s:fill_lite, [ 74,  237, s:lblu2, s:grey3, 0 ]),
          \"XBufLineFill"    : s:bg(s:fill_lite, [ 248, 234, s:lgry3, s:blak3, 0 ]),
          \"XTabLineSelMod"  : [ 203,  237, s:redli, s:grey3, 1 ],
          \"XTabLineSel"     : [ 74,  237, s:lblu2, s:grey3, 1 ],
          \"XTabLineMod"     : [ 248, 234, s:lgry3, s:blak3, 0 ],
          \"XTabLine"        : [ 248, 234, s:lgry3, s:blak3, 0 ],
          \"XTabLineFill"    : s:bg(s:fill_lite, [ 248, 234, s:lgry3, s:blak3, 0 ]),
          \"XTabLineNumSel"  : [ 237, 150, s:grey3, s:gren1, 0 ],
          \"XTabLineNum"     : [ 180, 234, s:yelw2, s:blak3, 0 ]},
      \'extra': {
          \"XBufLineSpecial" : [ 237, 150, s:grey3, s:gren1, 0 ],
          \"XBufLineMod"     : s:bg(s:fill_lite, [ 203, 237, s:redli, s:grey3, 0 ]),
          \"XBufLineModSel"  : [ 160, 74, '#cf0000', s:lblu2, 1 ],
          \"XBufLineModAct"  : [ 160, 237, '#cf0000', s:blak3, 1 ],
          \"XBufLinePinned"  : [ 251, 17,  s:lgry1, s:dblu1, 0 ]}
      \} }


fun! xtabline#themes#init()
  for theme in keys(s:Themes)
    call xtabline#hi#generate(s:Themes[theme]())
  endfor
endfun
