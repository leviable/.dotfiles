-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)
-- ###############################
--
-- Exit Insert Mode with jj/jk
--
-- ###############################
vim.keymap.set("i", "jj", "<esc>", { noremap = true, silent = true, desc = "Resume" })
vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "Resume" })
-- ###############################
--
-- Tabularize
--
-- ###############################

-- Use Tabularize to set shortcut `,aa` to align on pipes
vim.keymap.set("n", "<leader>tt", ":Tab /|<CR>")
vim.keymap.set("v", "<leader>tt", ":Tab /|<CR>")

-- Align Given/Then/When/And/But on the space after word
vim.keymap.set("n", "<leader>ts", ":Tab /^[ ]\\+\\(Given\\|When\\|Then\\|And\\|But\\)\\+\\zs/r0c1l0<CR>")
vim.keymap.set("v", "<leader>ts", ":Tab /^[ ]\\+\\(Given\\|When\\|Then\\|And\\|But\\)\\+\\zs/r0c1l0<CR>")
