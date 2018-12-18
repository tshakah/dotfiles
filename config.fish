if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -g theme_display_vi yes
set -g theme_display_hg yes
set -g theme_show_exit_status yes
set -g theme_color_scheme gruvbox
set -Ux BAT_THEME gruvbox
set --universal fish_user_paths $fish_user_paths ~/.npm/node_modules/bin/

fish_vi_key_bindings
fish_default_key_bindings -M insert
bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
bind -M insert \e\[1\;5C forward-word
bind -M insert \e\[1\;5D backward-word
bind -M visual \e\[1\;5C forward-word
bind -M visual \e\[1\;5D backward-word

eval (direnv hook fish)

alias rg "rg -S -M 200 --glob '!vendor' --glob '!data'"
alias vi "nvim"
alias vpn='z vpn; and sudo openvpn capvpn.ovpn'
