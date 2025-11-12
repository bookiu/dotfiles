vim.opt.shada = "'100,<50,s10,h"
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd("normal! g`\"")
        end
    end,
})
