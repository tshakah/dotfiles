if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -g theme_show_exit_status yes
set -g theme_color_scheme gruvbox
set -Ux BAT_THEME base16
set -Ux NODE_PATH "~/.npm"
set -Ux ERL_AFLAGS "-kernel shell_history enabled"
set -gx EDITOR nvim
set -g fish_term24bit 1

set -x FZF_DEFAULT_COMMAND "rg -S --files --follow --hidden --glob '!.git' --glob '!vendor' --glob '!data' --color=always"
set -x FZF_DEFAULT_OPTS "
  --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
"
set -x FZF_CTRL_T_OPTS "--height 100% --preview '(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500'"

set -e fish_user_paths

bash "$HOME/.config/nvim/plugged/gruvbox/gruvbox_256palette.sh"

set --universal fish_user_paths $fish_user_paths ~/.npm/bin/
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
alias pba 'z pba; and nix-shell'
alias dash 'z dev_dashboard; and nix-shell'
alias our 'z adventure; and nix-shell'
alias ner 'z ner; and nix-shell'
alias dot 'z dotfiles'
alias scr 'z scripts'
alias ls '~/source/scripts/lc.sh'
alias cat '~/source/scripts/lc.sh'
alias git '~/source/scripts/git.sh'
alias rgr '~/source/scripts/rgr.sh'
alias ssh 'env TERM=xterm-256color ssh'

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

function ensure
    mkdir -p (dirname $argv)
    touch $argv
end
