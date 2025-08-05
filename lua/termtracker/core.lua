local core = {}

function core:setup()
    self.terminals = {}
end

---Add a new buffer as a new terminal to track
---@param bufnr integer buffer number to track
function core:addTerminalBufferNumber(bufnr)
    self.terminals[bufnr] = {
        opened_at = os.date("%Y-%m-%d %H:%M:%S"),
        name = vim.api.nvim_buf_get_name(bufnr)
    }
end

---Remove terminal buffer number if it exists
---@param bufnr integer buffer number to remove
function core:removeTerminalBufferNumber(bufnr)
    if self.terminals[bufnr] then
        self.terminals[bufnr] = nil
    end
end

function core:getTerminals()
    return self.terminals
end

return core
