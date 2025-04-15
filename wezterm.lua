local wezterm = require 'wezterm'
local act = wezterm.action

local config = {
  color_scheme = 'Everforest Dark (Gogh)',
  enable_tab_bar = false,
  front_end = "WebGpu",
  font = wezterm.font('Inconsolata Nerd Font'),
  font_size = 13,
  check_for_updates = false,
  scrollback_lines = 100000,
  force_reverse_video_cursor = true,
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  }
}

config.keys = {
  { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 4, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'waldorf.local',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = '10.10.10.1',
    -- The username to use on the remote host
    username = 'elishahastings',
  },
}

return config
