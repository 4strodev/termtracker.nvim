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

function core:openTerminal(opts)
    opts = opts or {}

    if opts.orientation == 'vertical' then
        -- Open horizontal split
        vim.cmd('vsplit')
    else
        -- Open horizontal split
        vim.cmd('split')
    end

    -- Get the current buffer and start a terminal in it
    vim.cmd('terminal')
    vim.cmd({ cmd = 'resize', args = { opts.size or '15' } })
end

function core:getTerminals()
    return self.terminals
end

return core
