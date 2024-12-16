# pane-surgeon.nvim

**Pane Surgeon** is a Neovim plugin for managing windows (splits) with precision. It provides commands to close windows in specific directions, highlight and select windows to keep open, and close the rest.

## Features

- Close all windows in a specific direction (`left`, `right`, `top`, `bottom`).
- Highlight and select windows to keep open, and close the unselected ones.
- User-friendly commands to manage complex layouts.

## Installation

### Using `lazy.nvim`

Add the following to your `lazy.nvim` configuration:

```lua
{
  "tomxkay/pane-surgeon.nvim",
  config = function()
    require("pane_surgeon").setup()
  end,
}
```

| Command                       | Description                                               |
| ----------------------------- | --------------------------------------------------------- |
| `:PaneSurgeonCloseLeft`       | Closes all windows to the **left** of the active window.  |
| `:PaneSurgeonCloseRight`      | Closes all windows to the **right** of the active window. |
| `:PaneSurgeonCloseTop`        | Closes all windows **above** the active window.           |
| `:PaneSurgeonCloseBottom`     | Closes all windows **below** the active window.           |
| `:PaneSurgeonSelect`          | Toggles the **selection state** of the current window.    |
| `:PaneSurgeonCloseUnselected` | Closes all windows **except** the selected ones.          |
