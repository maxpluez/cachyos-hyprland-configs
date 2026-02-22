source /usr/share/cachyos-fish-config/cachyos-config.fish
nvm use lts
starship init fish | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

alias chrome='google-chrome-stable'
alias logout='hyprctl dispatch exit'
