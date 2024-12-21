local M = {}

local selected_windows = {}

local function apply_selection_visuals()
  for win_id, _ in pairs(selected_windows) do
    vim.api.nvim_set_option_value("winhighlight", "Normal:SelectedWindow", { scope = "local", win = win_id })
  end
end

local function clear_selection_visuals(win_id)
  vim.api.nvim_set_option_value("winhighlight", "Normal:", { scope = "local", win = win_id })
end

function M.toggle_window_selection(win_id)
  if selected_windows[win_id] then
    selected_windows[win_id] = nil
    clear_selection_visuals(win_id)
    vim.notify("Window " .. win_id .. " deselected.")
  else
    selected_windows[win_id] = true
    apply_selection_visuals()
    vim.notify("Window " .. win_id .. " selected.")
  end
end

function M.close_unselected_windows()
  local all_windows = vim.api.nvim_tabpage_list_wins(0)

  if vim.tbl_isempty(selected_windows) then
    vim.notify("No windows selected to keep open.", vim.log.levels.WARN)
    return
  end

  for _, win_id in ipairs(all_windows) do
    if not selected_windows[win_id] then vim.api.nvim_win_close(win_id, true) end
  end

  selected_windows = {}
end

function M.close_selected_windows()
  if vim.tbl_isempty(selected_windows) then
    vim.notify("No windows selected to close.", vim.log.levels.WARN)
    return
  end

  for win_id, _ in pairs(selected_windows) do
    vim.api.nvim_win_close(win_id, true)
  end

  selected_windows = {}
  vim.notify "Selected windows closed."
end

return M
