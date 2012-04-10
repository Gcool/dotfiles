set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="aiseered"

hi Normal guifg=lightred guibg=#600000
hi Cursor guifg=bg guibg=fg
hi ErrorMsg guibg=red ctermfg=1
hi Search term=reverse ctermfg=darkred ctermbg=lightred guibg=lightred guifg=#060000

hi Comment guifg=#ffffff
hi Constant guifg=#88ddee
hi String guifg=#ffcc88
hi Character guifg=#ffaa00
hi Number guifg=#88ddee
hi Identifier guifg=#cfcfcf
hi Statement guifg=#eeff99 gui=bold
hi PreProc guifg=firebrick1 gui=italic
hi Type guifg=#88ffaa gui=none
hi Special guifg=#ffaa00
hi SpecialChar guifg=#ffaa00
hi StorageClass guifg=#ddaacc
hi Error guifg=red guibg=white
