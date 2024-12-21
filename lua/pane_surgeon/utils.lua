local M = {}

function M.collect_windows_to_close(layout, current_win, direction, current_pos)
  local windows_to_close = {}

  if layout[1] == "leaf" then
    local win_id = layout[2]
    if win_id ~= current_win then
      local win_pos = vim.api.nvim_win_get_position(win_id)

      if direction == "left" and win_pos[2] < current_pos[2] then
        table.insert(windows_to_close, win_id)
      elseif direction == "right" and win_pos[2] > current_pos[2] then
        table.insert(windows_to_close, win_id)
      elseif direction == "top" and win_pos[1] < current_pos[1] then
        table.insert(windows_to_close, win_id)
      elseif direction == "bottom" and win_pos[1] > current_pos[1] then
        table.insert(windows_to_close, win_id)
      end
    end
  else
    for _, child in ipairs(layout[2]) do
      vim.list_extend(windows_to_close, M.collect_windows_to_close(child, current_win, direction, current_pos))
    end
  end

  return windows_to_close
end

function M.setup_highlight() vim.api.nvim_set_hl(0, "SelectedWindow", { bg = "#3c3834", fg = "#000000", bold = true }) end

return M
