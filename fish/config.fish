if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

zoxide init fish | source

set -g theme_show_exit_status yes
set -g theme_color_scheme base16-dark
set -g theme_display_nix yes
set -gx BAT_THEME ansi
set -gx NODE_PATH "~/.npm"
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx EDITOR nvim
set -gx NIX_SHELL_PROMPT $SHLVL
set -g fish_term24bit 1

set -x FZF_DEFAULT_COMMAND "rg -S --files --follow --hidden --glob '!.git' --glob '!vendor' --glob '!data' --color=always"
set -x FZF_DEFAULT_OPTS "
  --color fg:#ebdbb2,bg:#2b3339,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
"
set -x FZF_CTRL_T_OPTS "--height 100% --preview '(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500'"

set -e fish_user_paths

contains $fish_user_paths ~/.npm/bin; or set -Ua fish_user_paths ~/.npm/bin
contains $fish_user_paths ~/.cargo/bin; or set -Ua fish_user_paths ~/.cargo/bin
contains $fish_user_paths ~/.local/bin; or set -Ua fish_user_paths ~/.local/bin
contains $fish_user_paths ~/.mix/escripts; or set -Ua fish_user_paths ~/.mix/escripts

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
alias du 'dust'
alias dot 'z dotfiles'
alias scr 'z scripts'
alias ls '~/source/scripts/lc.sh'
alias cat '~/source/scripts/lc.sh'
alias git '~/source/scripts/git.sh'
alias rgr '~/source/scripts/rgr.sh'
alias ssh 'env TERM=xterm-256color ssh'
alias rm 'rm -I --preserve-root'
alias gti git
alias google-chrome google-chrome-stable

source ~/.config/fish/gnupg.fish

function ns
  if count $argv > /dev/null
    z $argv
  end

  nix-shell
end

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

starship init fish | source
