return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local util = require("null-ls.utils")

      -- Map local file paths to container paths
      local function container_path(file)
        local local_path = "/Users/wouter/work/fivex-8.x/html"
        local docker_path = "/var/www/html"
        local mapped_path = file:gsub("^" .. vim.pesc(local_path), docker_path)
        return mapped_path
      end

      -- Function to get phpcs configuration file
      local get_phpcs_config = function(params)
        local git_root = util.root_pattern(".git")(params.bufname)
        if git_root and vim.fn.filereadable(git_root .. "/html/phpcs.xml") == 1 then
          local config_path = git_root .. "/html/phpcs.xml"
          local mapped_config_path = container_path(config_path)
          return mapped_config_path
        end
        return nil
      end

      -- Setup null-ls
      null_ls.setup({
        sources = {
          -- PHPCS Diagnostics
          null_ls.builtins.diagnostics.phpcs.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            command = "docker",
            args = function(params)
              local phpcs_config = get_phpcs_config(params)
              if not phpcs_config then
                print("phpcs.xml not found!")
                return {}
              end
              return {
                "exec",
                "apache_prod_8.x",
                "/var/www/html/vendor/bin/phpcs",
                "--standard=" .. phpcs_config,
                "--report=json",
                "--stdin-path=" .. container_path(params.bufname),
                container_path(params.bufname),
              }
            end,
            on_output = function(params)
              local ok, json = pcall(vim.json.decode, params.err)
              if not ok or not json or not json.files then
                return {}
              end
              local diagnostics = {}
              local current_file = container_path(params.bufname)
              local file_diagnostics = json.files[current_file] or json.files["STDIN"]
              if not file_diagnostics or not file_diagnostics.messages then
                print("No diagnostics for file:", current_file)
                return diagnostics
              end
              for _, message in ipairs(file_diagnostics.messages) do
                table.insert(diagnostics, {
                  row = message.line,
                  col = message.column,
                  message = message.message,
                  severity = message.type == "ERROR" and 1 or 2,
                  source = "phpcs",
                })
              end
              return diagnostics
            end,
          }),
          -- PHPCBF Formatting (On selected region)
          null_ls.builtins.formatting.phpcbf.with({
            method = null_ls.methods.FORMATTING,
            command = "docker",
            args = function(params)
              local phpcs_config = get_phpcs_config(params)
              if not phpcs_config then
                print("phpcs.xml not found!")
                return {}
              end
              return {
                "exec",
                "apache_prod_8.x",  -- Ensure this container name is correct
                "/var/www/html/vendor/bin/phpcbf",
                "--standard=" .. phpcs_config,
                "--quiet",
                "--stdin-path=" .. container_path(params.bufname),
                container_path(params.bufname),
              }
            end,
            runtime_condition = function()
              return true
            end,
          }),
        },
      })

      function FormatAndRefresh()
        -- Trigger formatting with null-ls
        vim.lsp.buf.format({ async = true })

        -- After formatting, refresh diagnostics
        vim.diagnostic.reset()
      end

      vim.api.nvim_set_keymap("n", "<leader>f", [[:lua FormatAndRefresh()<CR>]], { noremap = true, silent = true })

    end,

  },
}

