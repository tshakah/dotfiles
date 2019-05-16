if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -g theme_display_hg yes
set -g theme_show_exit_status yes
set -g theme_color_scheme gruvbox
set -Ux BAT_THEME gruvbox
set -Ux ERL_AFLAGS "-kernel shell_history enabled"
set -gx EDITOR nvim

set --universal fish_user_paths $fish_user_paths ~/.npm/node_modules/bin/
set --universal fish_user_paths $fish_user_paths ~/.cargo/bin/

fish_default_key_bindings -M insert
bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
bind -M insert \e\[1\;5C forward-word
bind -M insert \e\[1\;5D backward-word
bind -M visual \e\[1\;5C forward-word
bind -M visual \e\[1\;5D backward-word

alias nix-shell "nix-shell --run fish"
alias rg "rg -S -M 200 --glob '!vendor' --glob '!data'"
alias vi 'nvim'
alias ls 'ls --color=tty'
alias hope 'z hope; and nix-shell'
alias imbr 'z imbr; and nix-shell'
alias aire 'z aire; and nix-shell'
alias ddw 'z worker; and nix-shell'
alias dash 'z dev_dashboard; and nix-shell'
alias our 'z adventure; and nix-shell'
alias ner 'z ner; and nix-shell'
alias dot 'z dotfiles'
alias scr 'z scripts'
alias pi 'pijul'

source ~/.config/fish/gnupg.fish

function vpn
    systemctl status openvpn-cap >/dev/null 2>&1

    if test $status -eq 0
        sudo systemctl stop openvpn-cap
        systemctl status openvpn-cap
    else
        sudo systemctl start openvpn-cap
        systemctl status openvpn-cap
    end
end
