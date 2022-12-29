local status, better_escape = pcall(require, "better_escape")
if not status then
    return
end

better_escape.setup({
    mapping = {'jk'}
})
