local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

-- ==========================================
-- Modern & Minimal Aesthetics
-- ==========================================

config = {
  
  -- Cursor
  default_cursor_style = 'BlinkingBar',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  animation_fps = 60,

  -- Scrolling
  scrollback_lines = 10000,

  -- Visual Bell
  visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 75,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 150,
  }
}

-- Sleek modern dark theme
config.color_scheme = 'Catppuccin Mocha'

-- Transparency & Blur
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30

-- Subtle, modern neon/glow gradient background
config.window_background_gradient = {
  orientation = 'Vertical',
  colors = {
    '#241b35', -- Very subtle deep purple/mauve glow at the top
    '#1e1e2e', -- Catppuccin Mocha base color in the middle
    '#11111b', -- Deep crust color at the bottom
  },
  interpolation = 'Linear',
  blend = 'Oklab',
}

-- High quality font configuration
config.font = wezterm.font('JetBrains Mono')
config.font_size = 14.0

-- Hide title bar (top bar) completely, keeping only window resize borders
config.window_decorations = 'RESIZE'

-- Add top padding above the tab/status bar (rendered as a colored top border)
config.window_frame = {
  border_top_height = '0px',
  border_top_color = '#241b35', -- Matches the glowing purple top of the gradient background
}

-- Balanced window margins for the terminal content
config.window_padding = {left = 12, right = 12, top = 12, bottom = 12 }

-- Minimal tab bar configuration (functioning as status line)
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- Hide the tab bar if we're using starship to show directory/branch.
config.enable_tab_bar = true

-- Custom styling for tab bar and cursor to blend perfectly into the window background
config.colors = {
  cursor_bg = '#89dceb', -- Vibrant sky blue/teal glow
  cursor_fg = '#11111b',
  tab_bar = {
    background = '#241b35', -- Matches the glowing purple top of the gradient background
    active_tab = {
      bg_color = '#241b35',
      fg_color = '#cdd6f4',
      intensity = 'Bold',
      underline = 'None',
    },
    inactive_tab = {
      bg_color = '#241b35',
      fg_color = '#7f849c',
    },
    inactive_tab_hover = {
      bg_color = '#313244',
      fg_color = '#cdd6f4',
    },
  },
}

config.keys = {                                                                            
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {                                                  
    key = 'LeftArrow',                               
    mods = 'OPT',                                    
    action = act.SendKey {                           
      key = 'b',                                     
      mods = 'ALT',                                  
    },                                               
  },                                                 
  {                                                  
    key = 'RightArrow',                              
    mods = 'OPT',                                    
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },                                                 
}

config.adjust_window_size_when_changing_font_size = false

-- ==========================================
-- Status Line: PWD & Git Branch Integration
-- ==========================================

-- Check status every 1 second
config.status_update_interval = 1000

-- Variables to cache the PWD and branch for the title formatting event
local current_cwd = ""
local current_branch = ""

-- Format the path to show only the last folder name or '~' for home
local function format_cwd(cwd)
  if not cwd or cwd == "" then return "" end
  if cwd == wezterm.home_dir then
    return "~"
  end
  local basename = cwd:match("([^/]+)$")
  return basename or cwd
end

-- Resolve working directory and git branch (works both normally and inside tmux)
local function get_cwd_and_branch(pane)
  local cwd = nil
  local branch = nil

  local process_name = pane:get_foreground_process_name()
  if process_name and process_name:find("tmux") then
    -- Retrieve the active pane's working directory from tmux
    local success, stdout, stderr = wezterm.run_child_process({
      "tmux", "display-message", "-p", "-F", "#{pane_current_path}"
    })
    if success then
      cwd = stdout:gsub("%s+$", "")
    end
  else
    -- Normal local pane directory detection
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
      cwd = cwd_uri.file_path
    end
  end

  -- Query Git branch for the resolved directory
  if cwd and cwd ~= "" then
    local success, stdout, stderr = wezterm.run_child_process({
      "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"
    })
    if success then
      branch = stdout:gsub("%s+$", "")
    end
  end

  return cwd, branch
end

-- Update tab bar status (Right side)
wezterm.on('update-right-status', function(window, pane)
  local cwd, branch = get_cwd_and_branch(pane)
  current_cwd = cwd or ""
  current_branch = branch or ""
  
  local formatted_cwd = format_cwd(current_cwd)
  local status_items = {}
  
  -- Render current directory
  if formatted_cwd ~= "" then
    table.insert(status_items, { Background = { Color = '#241b35' } })
    table.insert(status_items, { Foreground = { Color = '#89b4fa' } }) -- Pastel Blue
    table.insert(status_items, { Text = ' 󰉖 ' .. formatted_cwd .. ' ' })
  end
  
  -- Render git branch
  if current_branch ~= "" then
    table.insert(status_items, { Background = { Color = '#241b35' } })
    table.insert(status_items, { Foreground = { Color = '#a6e3a1' } }) -- Pastel Green
    table.insert(status_items, { Text = '  ' .. current_branch .. ' ' })
  end

  -- Render Leader key indicator (if leader key is activated in the future)
  if window:leader_is_active() then
    table.insert(status_items, { Background = { Color = '#f38ba8' } }) -- Pastel Red
    table.insert(status_items, { Foreground = { Color = '#11111b' } })
    table.insert(status_items, { Text = ' LEADER ' })
  end

  -- Add a bit of spacing to the right so it doesn't touch the window border
  table.insert(status_items, { Background = { Color = '#241b35' } })
  table.insert(status_items, { Text = '  ' })
  
  window:set_right_status(wezterm.format(status_items))
end)

-- Keep the OS window title in sync (read from cache to stay performant)
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local formatted_cwd = format_cwd(current_cwd)
  local title = formatted_cwd
  if current_branch ~= "" then
    title = title .. " ( " .. current_branch .. ")"
  end
  return title ~= "" and title or "wezterm"
end)

-- Hide the tab title (e.g., "1: riky@thinkpa") on the top left
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  return ''
end)

return config
