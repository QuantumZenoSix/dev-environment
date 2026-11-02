-- Debugger: nvim-dap + UI, inline variable values, and Mason-installed adapters
-- Keymaps live in config/keymaps.lua under <leader>D (plus F5/F9/F10); the first one used loads everything here.
-- Adapters are INSTALLED by mason-tool-installer (the `debuggers` list in plugins/lsp.lua);
-- mason-nvim-dap only WIRES them into nvim-dap (adapter definitions + default launch configurations).
--
-- Per-project launch configs: put a .vscode/launch.json in the project root - nvim-dap reads it automatically.
--
-- What each plugin does:
--   nvim-dap              The debugger client itself (breakpoints, stepping, sessions).
--   nvim-dap-ui           Panels (scopes, stacks, watches, breakpoints, REPL, console) that open when a session
--                         starts and close when it ends. <leader>Du toggles them, <leader>De evaluates the
--                         expression under the cursor / the visual selection.
--   nvim-nio              Async library required by nvim-dap-ui - nothing to configure.
--   nvim-dap-virtual-text Shows variable values at the end of each line while stopped (e.g. `x = 41`).
--   mason-nvim-dap        Wires the Mason-installed adapters into nvim-dap with its default configs:
--                         codelldb (C/C++/Rust/Zig), bash, delve (Go). It does NOT install anything.
--   nvim-dap-python       Python via Mason's debugpy; also provides <leader>Dm / <leader>DM (debug test method/class).
--   Set up by hand below: JavaScript/TypeScript (js-debug-adapter), Perl (perl-debug-adapter),
--                         Ruby (rdbg, only if installed) - mason-nvim-dap doesn't cover these well.
--
-- Signs: ● breakpoint, ◆ conditional breakpoint, ◉ log point, ○ rejected breakpoint, → current line (highlighted).

return {
  {
    'mfussenegger/nvim-dap',
    lazy = true, -- loaded on the first require('dap') from a keymap
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',              -- required by nvim-dap-ui
      'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap-python',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- ── Signs ───────────────────────────────────────────────────────────
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
      local signs = {
        DapBreakpoint          = { text = '●', texthl = 'DiagnosticError' },
        DapBreakpointCondition = { text = '◆', texthl = 'DiagnosticWarn' },
        DapLogPoint            = { text = '◉', texthl = 'DiagnosticInfo' },
        DapBreakpointRejected  = { text = '○', texthl = 'DiagnosticHint' },
        DapStopped             = { text = '→', texthl = 'DiagnosticOk', linehl = 'DapStoppedLine' },
      }
      for name, sign in pairs(signs) do vim.fn.sign_define(name, sign) end

      -- ── UI: open when a session starts, close when it ends ──────────────
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- ── Inline variable values next to the code while stopped ───────────
      require('nvim-dap-virtual-text').setup({
        commented = false,           -- true prefixes values with the language's comment string
        virt_text_pos = 'eol',
      })

      -- ── Adapters via mason-nvim-dap (codelldb, bash, delve use its defaults) ──
      require('mason-nvim-dap').setup({
        ensure_installed = {},           -- mason-tool-installer (plugins/lsp.lua) does the installing
        automatic_installation = false,
        handlers = {
          function(config) require('mason-nvim-dap').default_setup(config) end,
          python = function() end,       -- handled by nvim-dap-python below (adds test_method/test_class)
          js = function() end,           -- configured manually below
        },
      })

      -- ── Python (debugpy from Mason's venv) ──────────────────────────────
      require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')

      -- ── JavaScript / TypeScript (js-debug-adapter, Node only) ───────────
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = { command = 'js-debug-adapter', args = { '${port}' } },
      }
      for _, ft in ipairs({ 'javascript', 'typescript' }) do
        dap.configurations[ft] = {
          { type = 'pwa-node', request = 'launch', name = 'Launch current file (node)', program = '${file}', cwd = '${workspaceFolder}' },
          { type = 'pwa-node', request = 'attach', name = 'Attach to process', processId = require('dap.utils').pick_process, cwd = '${workspaceFolder}' },
        }
      end

      -- ── Perl (perl-debug-adapter; needs PadWalker, Arch pkg perl-padwalker) ──
      dap.adapters.perl = { type = 'executable', command = 'perl-debug-adapter', args = {} }
      dap.configurations.perl = {
        { type = 'perl', request = 'launch', name = 'Launch current file', program = '${file}', cwd = '${workspaceFolder}' },
      }

      -- ── Ruby (rdbg, from the `debug` gem) ───────────────────────────────
      if vim.fn.executable('rdbg') == 1 then
        dap.adapters.ruby = function(callback, config)
          callback({
            type = 'server',
            host = '127.0.0.1',
            port = '${port}',
            executable = {
              command = 'rdbg',
              args = { '--open', '--port', '${port}', '-c', '--', 'ruby', config.program },
            },
          })
        end
        dap.configurations.ruby = {
          { type = 'ruby', request = 'attach', name = 'Run current file', program = '${file}', localfs = true },
        }
      end
    end,
  },

  -- Listed separately so lazy.nvim knows they're lazy; they're loaded as nvim-dap's dependencies
  { 'rcarriga/nvim-dap-ui', lazy = true },
  { 'nvim-neotest/nvim-nio', lazy = true },
  { 'theHamsta/nvim-dap-virtual-text', lazy = true },
  { 'mfussenegger/nvim-dap-python', lazy = true },
  { 'jay-babu/mason-nvim-dap.nvim', lazy = true },
}


-- ══════════════════════════════════════════════════════════════════════════════════════════════════
-- USAGE NOTES
-- ══════════════════════════════════════════════════════════════════════════════════════════════════
--
-- 1. What F5 / <leader>Dc (dap.continue) does - depends on state:
--    a) No session      -> collects launch configs for this filetype (+ .vscode/launch.json), runs it directly if
--                          there's one, shows a picker if several (Python always has several), then runs the
--                          program until a breakpoint or the end.
--    b) Paused          -> resumes until the next breakpoint or the end.
--    c) Running, not paused -> menu: terminate / pause a thread / restart / disconnect / start another config.
--
-- 2. Running a plain script (e.g. Python)
--    - F5 -> pick `file` (or `file:args` to be prompted for sys.argv, e.g. `3 5`).
--    - It runs in the dapui console (a real terminal). For input(): move into the console window (<C-w>j), press i, type.
--    - With no breakpoints it runs straight through. The UI auto-closes when the session ends, so a short script's
--      output disappears almost immediately - set a breakpoint, or reopen with <leader>Du.
--    - Python interpreter: $VIRTUAL_ENV / $CONDA_PREFIX, else venv/.venv/env/.env in the project, else Mason's
--      debugpy venv (fine for plain scripts, but packages you installed elsewhere won't be importable).
--
-- 3. Web apps - F5's built-in configs run the CURRENT FILE, so it serves only if that file starts the server:
--    - Python: app.py ending in app.run() (Flask) / uvicorn.run(app) (FastAPI) -> pick `file`.
--    - Django: open manage.py, pick `file:args`, enter `runserver --noreload`.
--    - Node:   server.js that calls app.listen(...) -> "Launch current file (node)".
--    Apps started by a framework or npm command (flask run, uvicorn main:app, npm run dev) need a
--    .vscode/launch.json in the project root - nvim-dap reads it automatically and adds its entries to the F5 picker:
--
--      {
--        "version": "0.2.0",
--        "configurations": [
--          { "name": "FastAPI (uvicorn)", "type": "debugpy", "request": "launch",
--            "module": "uvicorn", "args": ["main:app", "--port", "8000"], "justMyCode": true },
--          { "name": "Flask", "type": "debugpy", "request": "launch",
--            "module": "flask", "args": ["run", "--no-debugger", "--no-reload"] },
--          { "name": "npm run dev", "type": "pwa-node", "request": "launch",
--            "runtimeExecutable": "npm", "runtimeArgs": ["run", "dev"], "cwd": "${workspaceFolder}" }
--        ]
--      }
--
--    JS configs must use "type": "pwa-node" (the only Node adapter defined above) - "node" from older VS Code
--    examples won't resolve.
--
--    While serving:
--    - The server keeps running until <leader>Dt (the UI stays open since the session doesn't end).
--    - Breakpoints in route handlers are hit when a request comes in (browser / curl); F5 continues and sends the response.
--    - While paused, the server can't answer requests - the browser just waits.
--    - Disable auto-reload (--no-reload / --noreload): reloaders restart the app in a new process, which can make
--      breakpoints stop working.
--
--    Not covered: front-end JavaScript running in the browser (React etc.) - that needs pwa-chrome, not set up here.
