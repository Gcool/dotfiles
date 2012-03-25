" Colors
colorscheme elflord 

" General
syntax on
set ignorecase
set incsearch
set nohlsearch
set number
set ruler
set showcmd
set showmatch
set showmode
set title

" Indenting
set autoindent
set nocindent
set smartindent

" Mouse
if has('mouse')
  set mouse=a
endif

" Python
autocmd FileType python let python_highlight_all = 1
autocmd FileType python let python_slow_sync = 1
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4
autocmd FileType python set completeopt=preview

" Make shell and perl scripts executable
au BufWritePost   *.sh             !chmod +x %
au BufWritePost   *.pl             !chmod +x %

" PKGBUILD
autocmd FileType PKGBUILD set expandtab shiftwidth=2 softtabstop=4

" Shell
autocmd FileType sh set expandtab shiftwidth=2 softtabstop=4

" Misc
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
