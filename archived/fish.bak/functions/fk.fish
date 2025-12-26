function fk
    sudo pacman -Syu 2>&1 | grep -v 'is newer than'
end
