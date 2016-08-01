" lets the cursor position on opening be at first line, because of the general
" remembering of the cursor position, vim jumps to the last used position. But
" that's not a good behaviour for git commit messages.
all setpos('.', [0, 1, 1, 0])
