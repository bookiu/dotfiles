if !exists("g:loaded_airline")
    set ruler
    set rulerformat=%-14.(%l,%c%V%)\ %P
    " 在状态栏显示正在输入的命令
    set showcmd
    " 左下角显示当前vim模式
    set showmode
    " 图形界面的状态栏
    set statusline=
    set statusline+=%1*
    set statusline+=\ %t%m%r%h%y
    set statusline+=\ %2*
    set statusline+=\ %w[%<%.36(%{getcwd()}%)]
    set statusline+=\ %3*
    set statusline+=%=
    set statusline+=%6*
    set statusline+=\ [%{&fileformat},%{&fileencoding}%{(exists(\"+bomb\")\ &&\ &bomb)?\"-BOM\":\"\"}]
    set statusline+=\ %l/%L
    set statusline+=\ %=\[%P]
    set statusline+=\ " 添加一个空格
    " 命令行（在状态行下）的高度，默认为1，这里是2
    set laststatus=2

    " 防止错误整行标红导致看不清
    highlight clear SpellBad
    highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
    highlight clear SpellCap
    highlight SpellCap term=underline cterm=underline
    highlight clear SpellRare
    highlight SpellRare term=underline cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal term=underline cterm=underline
    " 自定义用户颜色
    hi User1 ctermfg=15 ctermbg=37 guifg=#ffffff guibg=#03acb1
    hi User2 ctermfg=15 ctermbg=30 guifg=#ffffff guibg=#028785
    hi User3 ctermfg=15 ctermbg=35 guifg=#ffffff guibg=#04b15e
    hi User4 ctermfg=15 ctermbg=70 guifg=#ffffff guibg=#83b901
    hi User5 ctermfg=15 ctermbg=214 guifg=#ffffff guibg=#fd8300
    hi User6 ctermfg=15 ctermbg=214 guifg=#ffffff guibg=#16528e

    "设置标记一列的背景颜色和数字一行颜色一致
    hi! link SignColumn   LineNr
    hi! link ShowMarksHLl DiffAdd
    hi! link ShowMarksHLu DiffChange
endif

