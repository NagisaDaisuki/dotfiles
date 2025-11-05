function fish_greeting
    echo -ne '\x1b[38;5;16m' # Set colour to primary

    echo '  _  ___ _____  _ ______          _ _  ' | lolcat
    echo ' | |/ (_)  __ \(_)  ____|        | (_) ' | lolcat
    echo ' |  /  _| |__) |_| |__ _   _     | |_  ' | lolcat
    echo ' |  < | |  _  /| |  __| | | |_   | | | ' | lolcat
    echo ' | . \| | | \ \| | |  | |_| | |__| | | ' | lolcat
    echo ' |_|\_\_|_|  \_\_|_|   \__,_|\____/|_| ' | lolcat

    set_color normal
    fastfetch --key-padding-left 6 | lolcat -a -s 100
end
