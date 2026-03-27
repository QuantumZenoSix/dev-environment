vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local bufnr = args.buf
    -- Skip if not a normal file buffer
    if vim.bo[bufnr].buftype ~= ""          -- no buftype (help, terminal, quickfix, etc.)
      or vim.bo[bufnr].filetype == ""        -- or empty filetype (often scratch/new buffers)
      or not vim.api.nvim_buf_get_name(bufnr) -- or no file name
    then
      return
    end

    -- Only run for real file buffers
    vim.cmd("IBLDisable")
    -- vim.diagnostic.disable()

    -- vim.cmd("normal! 20dd")  -- optional: force recompute
    -- vim.cmd("normal! zx")  -- optional: force recompute
  end,
  desc = "Simulate toggles only on real file buffers",
})



-- Once neovim starts, create avante.md if we're in a git project fir and no avante.md
vim.api.nvim_create_autocmd("VimEnter", {
    -- VimEnter: After full startup, config & plugins loaded
    callback = function()
        local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):match("(.-)\n?$")
        if root and root ~= "" and vim.fn.filereadable(root .. "/avante.md") == 0 then
            local content = {
            "# Project Instructions - Strict Selected-Lines-Only Mode",
            "",
            "## Core Behavioral Rule (highest priority - always obey this unless explicitly told otherwise)",
            "",
            "- If I have selected lines of code, **ONLY** edit code from the **currently selected lines** (the lines I have visually selected / highlighted in Neovim when I send the request).",
            "- You may suggest edits to code directly relating to that line (for example if I'm in a function you can suggest edits to other parts of the function if they directly relate to changes we're makling in the selected lines of code or to other lines of code that call this function.",
            "- Never suggest moving code outside the selection, refactoring adjacent unselected code, or adding imports/references that would require unselected parts of the file.",
            "- If I have selected lines of code, you are to primarily consider the lines of code I've selected. You can look at other lines but give your core opinions on the code I've selected.",
            "",
            "## Response Style",
            "",
            "- Be concise.",
            "- If following the strict selected-lines rule, prefix important answers with: **[Selected-lines-only mode]**",
            "",
            "This rule exists because I usually work with small, focused selections and want to prevent context pollution / token waste / wrong assumptions.",
            "",
            "Thank you for strictly following this.",
            }      
            vim.fn.writefile(content, root .. "/avante.md")
        end
    end,
})






-- On first fold toggle (za) refresh fold method first with zx
vim.keymap.set('n', 'za', function()
  -- Run the sequence you want (zx + za)
  vim.cmd('normal! zxza')

  -- Immediately remove this temporary mapping
  -- so next za is the builtin one again
  vim.keymap.del('n', 'za')
end, { noremap = true, silent = true, desc = "One-time: zx + za (fold refresh + toggle)" })


