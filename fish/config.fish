zoxide init fish | source
direnv hook fish | source
starship init fish | source

set -U fish_color_command blue
set -g theme_show_exit_status yes
set -g theme_color_scheme base16-dark
set -g theme_display_nix yes
set -gx BAT_THEME ansi
set -gx NODE_PATH "~/.npm"
set -gx PNPM_HOME "~/.pnpm"
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx EDITOR nvim
set -gx NIX_SHELL_PROMPT $SHLVL
set -g fish_term24bit 1

set -x FZF_DEFAULT_COMMAND "rg -S --ignore-vcs --files --follow --hidden --glob '!.git' --glob '!vendor' --glob '!data' --color=always"
set -x FZF_DEFAULT_OPTS "
  --color fg:#ebdbb2,bg:#2b3339,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
  --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all
"
set -x FZF_CTRL_T_OPTS "--height 100% --preview '(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500'"

set -e fish_user_paths

contains $fish_user_paths ~/.pnpm; or set -Ua fish_user_paths ~/.pnpm
contains $fish_user_paths ~/.npm/bin; or set -Ua fish_user_paths ~/.npm/bin
contains $fish_user_paths ~/.cargo/bin; or set -Ua fish_user_paths ~/.cargo/bin
contains $fish_user_paths ~/.local/bin; or set -Ua fish_user_paths ~/.local/bin
contains $fish_user_paths ~/.mix/escripts; or set -Ua fish_user_paths ~/.mix/escripts
contains $fish_user_paths ~/.wine/bin; or set -Ua fish_user_paths ~/.wine/bin

fish_default_key_bindings -M insert
bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
bind -M insert \e\[1\;5C forward-word
bind -M insert \e\[1\;5D backward-word
bind -M visual \e\[1\;5C forward-word
bind -M visual \e\[1\;5D backward-word

# `gti` is an alias as if it were an `abbr` it would expand to the git bash script path
alias gti git
alias cat '~/source/dotfiles/scripts/lc.sh'
alias git '~/source/dotfiles/scripts/git.sh'
alias ls '~/source/dotfiles/scripts/lc.sh'
alias rgr '~/source/dotfiles/scripts/rgr.sh'
alias run-mix-tests '~/source/dotfiles/scripts/run-mix-tests.sh'
alias rm 'rm -I --preserve-root'
alias nix-shell "nix-shell --run fish"
alias ssh 'env TERM=xterm-256color ssh'
alias scp 'env TERM=xterm-256color scp'
alias gigalixir 'env TERM=xterm-256color gigalixir'
alias rg "rg -S -M 200 --hidden --glob '!vendor' --glob '!data' --glob '!.git'"
alias sudo-git 'GIT_SSH_COMMAND="ssh -i /home/elishahastings/.ssh/id_ed25519 -o IdentitiesOnly=yes" sudo -E git'
alias vi 'nvim'
alias speedtest 'wget -URL http://cachefly.cachefly.net/200mb.test -O /dev/null'
alias docker-ports 'docker ps --format "table {{.Names}}\t{{.Ports}}"'

abbr du 'dust'
abbr diff 'batdiff'
abbr google-chrome google-chrome-stable
abbr dco 'docker compose'
abbr lg 'lazygit'

source ~/.config/fish/gnupg.fish

function ns
  if count $argv > /dev/null
    z $argv
  end

  nix-shell
end

function nix-cleanup
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10
  sudo nix-collect-garbage -d
end

function update-all
  echo -ne "\e[36m\e[1mNeovim: update\e[0m\n"
  nvim --headless +PlugUpgrade +PlugUpdate +qa
  echo -ne "\n\n\e[36m\e[1mNixOS: update\e[0m\n"
  sudo nixos-rebuild switch --upgrade-all
  echo -ne "\n\n\e[36m\e[1mNixOS: cleanup\e[0m\n"
  nix-cleanup
  echo -ne "\n\n\e[36m\e[1mTLDR: update\e[0m\n"
  tldr --update
end

function ensure
  mkdir -p (dirname $argv)
  touch $argv
end

function fish_greeting
end

# https://jordanelver.co.uk/blog/2020/05/29/history-deleting-helper-for-fish-shell/
function dh -d "Fuzzily delete entries from your history"
  history | fzf | read -l item; and history delete --prefix "$item"
end

function fish_user_key_bindings
  bind \cl 'tput reset; clear; commandline -f repaint'
end
