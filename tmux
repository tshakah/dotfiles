# Remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
set -g focus-events on

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf

# Enable mouse mode
set -g mouse on

# Enable vi mode
setw -g mode-keys vi
set-option -g status-keys vi

# Don't rename windows automatically
set-option -g allow-rename off

# Use fish
set -g default-command /run/current-system/sw/bin/fish
set -g default-shell /run/current-system/sw/bin/fish

# Truecolour
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",*256col*:Tc"

## COLORSCHEME: gruvbox dark
set-option -g status "on"

# default statusbar color
set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

# default window title colors
set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

# default window with an activity alert
set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

# active window title colors
set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

# pane border
set-option -g pane-active-border-style fg=colour250 #fg2
set-option -g pane-border-style fg=colour237 #bg1

# message infos
set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

# writing commands inactive
set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

# pane number display
set-option -g display-panes-active-colour colour250 #fg2
set-option -g display-panes-colour colour237 #bg1

# clock
set-window-option -g clock-mode-colour colour109 #blue

# bell
set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
set-option -g status-justify "left"
set-option -g status-left-style none
set-option -g status-left-length "80"
set-option -g status-right-style none
set-option -g status-right-length "80"
set-window-option -g window-status-separator ""

set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
set-option -g status-right "#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %Y-%m-%d  %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h "

set-window-option -g window-status-current-format "#[fg=colour237, bg=colour214, nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I #[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I #[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"

# Fix clipboard
set-option -s set-clipboard off
bind P paste-buffer
#tmate doesn't work with these yet
#bind-key -T copy-mode-vi v send-keys -X begin-selection
#bind-key -T copy-mode-vi y send-keys -X rectangle-toggle
#unbind -T copy-mode-vi Enter
#bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'wl-copy'
#bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'
