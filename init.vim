for f in split(glob('~/source/dotfiles/vim/*.vim'), '\n')
  exe 'source' f
endfor
