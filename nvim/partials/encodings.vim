if has("multi_byte")
    " Vim内部使用的字符编码方式
    set encoding=utf-8
    " Vim对文件存档时候使用的编码方式
    set fileencoding=utf-8
    " Vim编码的自动识别，注意编码类型的顺序
    set fileencodings=ucs-bom,utf-8,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1
    " 下面这句只影响普通模式 (非图形界面) 下的 Vim。
    set termencoding=utf-8
    " 不使用 Unicode 签名
    set nobomb
    " 如遇Unicode值大于255的文本，不必等到��格再折行。
    set formatoptions+=m
    " 合并两行中文时，不在中间加空格：
    set formatoptions+=B
    " 默认文件编码
    set ffs=unix,dos,mac
    " menu language
    if has("gui_running")
        language message zh_CN.UTF-8
        set langmenu=zh_CN.UTF-8
    endif
endif

