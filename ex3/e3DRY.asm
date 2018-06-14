mov ax, 0fffeh      ;ax initalization
AGN:mov di, ax          ;can't do [ax+bx] so use di 
add [bx+di] 01h    ;increase if ax is pair
sub ax, 02h         ;go to the next pair index
jnz AGN             ;loop if not finished