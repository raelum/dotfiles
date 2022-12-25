local status, autopairs = pcall(require, "nvim-autopairs")
if not status then
    return
end

autopairs.setup({
    -- Disable autopair completion for Telescope
    -- Find out filetype by opening Telescope window and running ':echo &ft'
    disable_filetype = {'TelescopePrompt'}
})
