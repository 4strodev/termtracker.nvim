local core = {}

function core:setup(opts)
    self.terminals = {}
    self.opts = vim.tbl_extend("force", opts, { size = '15' })
end

---Add a new buffer as a new terminal to track
---@param bufnr integer buffer number to track
function core:addTerminalBufferNumber(bufnr)
    self.terminals[bufnr] = {
        opened_at = os.time(),
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

function core:openTerminal(opts, bufnr)
    opts = opts or {}

    local createNewBuffer = bufnr == nil or (not vim.api.nvim_buf_is_loaded(bufnr))

    if createNewBuffer then
        if opts.orientation == 'vertical' then
            -- Open horizontal split
            vim.cmd('vsplit')
        else
            -- Open horizontal split
            vim.cmd('split')
        end

        -- Get the current buffer and start a terminal in it
        vim.cmd('terminal')
    else
        local windows = vim.fn.win_findbuf(bufnr)
        if #windows > 0 then
            vim.api.nvim_set_current_win(windows[1])
        else
            if opts.orientation == 'vertical' then
                -- Open horizontal split
                vim.cmd('vsplit')
            else
                -- Open horizontal split
                vim.cmd('split')
            end
            vim.api.nvim_set_current_buf(bufnr)
        end
    end

    vim.cmd({ cmd = 'resize', args = { opts.size or self.opts.size } })
    vim.cmd("startinsert")
end

---@return { data: { opened_at: number, name: string }, bufnr: number } | nil
function core:getLatestTerminal()
    local max = 0
    local latestTerminal = nil
    local latestBufnr = nil
    for bufnr, terminalEntry in pairs(self.terminals) do
        if max < terminalEntry.opened_at then
            max = terminalEntry.opened_at
            latestTerminal = terminalEntry
            latestBufnr = bufnr
        end
    end

    return { data = latestTerminal, bufnr = latestBufnr }
end

function core:getTerminals()
    return self.terminals
end

return core
