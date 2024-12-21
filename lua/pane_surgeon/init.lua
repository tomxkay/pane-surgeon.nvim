local session = require "pane_surgeon.session"
local utils = require "pane_surgeon.utils"
local selection = require "pane_surgeon.selection"

local M = {}

function M.close_windows(direction)
  session.save_session()

  local current_win = vim.api.nvim_get_current_win()
  local layout = vim.api.nvim_eval "winlayout()"
  local current_pos = vim.api.nvim_win_get_position(current_win)

  local windows_to_close = utils.collect_windows_to_close(layout, current_win, direction, current_pos)

  if #windows_to_close == 0 then
    vim.notify("No windows to close in the " .. direction .. " direction.", vim.log.levels.INFO)
    return
  end

  for _, win_id in ipairs(windows_to_close) do
    vim.api.nvim_win_close(win_id, true)
  end
end

function M.select_windows() selection.toggle_window_selection(vim.api.nvim_get_current_win()) end

function M.close_unselected_windows() selection.close_unselected_windows() end

function M.close_selected_windows() selection.close_selected_windows() end

function M.restore_session() session.restore_session() end

function M.setup()
  utils.setup_highlight()
  session.setup_autocmds()

  vim.api.nvim_create_user_command("PaneSurgeonCloseLeft", function() M.close_windows "left" end, {})
  vim.api.nvim_create_user_command("PaneSurgeonCloseRight", function() M.close_windows "right" end, {})
  vim.api.nvim_create_user_command("PaneSurgeonCloseTop", function() M.close_windows "top" end, {})
  vim.api.nvim_create_user_command("PaneSurgeonCloseBottom", function() M.close_windows "bottom" end, {})

  vim.api.nvim_create_user_command("PaneSurgeonSelect", function() M.select_windows() end, {})
  vim.api.nvim_create_user_command("PaneSurgeonCloseSelected", function() M.close_selected_windows() end, {})
  vim.api.nvim_create_user_command("PaneSurgeonCloseUnselected", function() M.close_unselected_windows() end, {})

  vim.api.nvim_create_user_command("PaneSurgeonRestore", function() M.restore_session() end, {})
end

return M
