" curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tomasr/molokai'
Plug 'arzg/vim-colors-xcode'
Plug 'gruvbox-community/gruvbox'
Plug 'arcticicestudio/nord-vim'
"Plug 'ueaner/molokai'

" Syntax
Plug 'isobit/vim-caddyfile'

" Go Language
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" tmuxline
Plug 'edkolev/tmuxline.vim'
call plug#end()

" For vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" coc
runtime! partials/plugins/coc.vim
" airline
runtime! partials/plugins/airline.vim
" tmuxline
runtime! partials/plugins/tmuxline.vim
