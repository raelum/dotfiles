local status, indent_blankline = pcall(require, "indent_blankline")
if not status then
    return
end

indent_blankline.setup({});
