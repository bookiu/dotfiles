augroup vimrc_colorscheme
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
  autocmd FileType dbout syn match dbout_null /(null)/ | hi link dbout_null Comment
  autocmd ColorScheme xcodelight hi VertSplit guibg=NONE guifg=#8a99a6 | hi Comment gui=italic
augroup END

let s:bg_color = $NVIM_COLORSCHEME_BG ==? 'light' ? 'light' : 'dark'
silent exe 'set background='.s:bg_color
set synmaxcol=300                                                                 " Use syntax highlighting only for 300 columns
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_selection = 0
filetype plugin indent on
syntax on
let s:colorscheme = $NVIM_COLORSCHEME_BG ==? 'light' ? 'xcodelight' : 'molokai'
silent! exe  'colorscheme '.s:colorscheme

set t_Co=256
if has("termguicolors")
    " fix bug for vim
    set t_8f=^[[38;2;%lu;%lu;%lum
    set t_8b=^[[48;2;%lu;%lu;%lum

    " enable true color
    "set termguicolors
endif
