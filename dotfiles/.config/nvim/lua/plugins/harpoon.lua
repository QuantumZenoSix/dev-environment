return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
        settings = {
          save_on_toggle = true, -- Save marks when toggling the menu
          sync_on_ui_close = true, -- Sync marks when closing the menu
        },
    })


    end,
}
