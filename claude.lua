local M = {}

-- configuration
M.config = {
    api_key = os.getenv("ANTHROPIC_API_KEY"),
    model = "claude-3-5-sonnet-latest",
    system = "Be concise and direct in your responses. Respond without unnecessary explanation.",
    mark = {
        first = "claude context start",
        final = "claude context end",
    },
    keymaps = {
        ask = "<leader>c",
        mark = "<leader>cm",
    }
}

function M.setup(opts)
  -- called by user in init.lua to customize configuration
  -- e.g. require('claude').setup({ system = "Be concise." })
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- helpers
function M.get_comment_tag()
  local comment_map = {
    c = "// ",
    python = "# ",
    javascript = "// ",
    typescript = "// ",
    lua = "-- ",
    go = "// ",
    sh = "# ",
  }
  local ft = vim.bo.filetype
  return comment_map[ft] or "// "
end

function M.get_visual_selection()
  local first = vim.fn.line('v')
  local final = vim.fn.line('.')
  return math.min(first, final), math.max(first, final)
end

function M.collect_context()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local contexts = ""
  local in_context = false

  local comment = M.get_comment_tag()
  
  for _, line in ipairs(lines) do
    if line == comment .. M.config.mark.first then
      in_context = true
    elseif line == comment .. M.config.mark.final then
      in_context = false
      contexts = contexts .. "\n"
    elseif in_context then
      contexts = contexts .. line .. "\n"
    end
  end
  
  return contexts
end

-- main functions
function M.mark()
  local first, final = M.get_visual_selection()
  local comment = M.get_comment_tag()
  vim.fn.append(final, comment .. M.config.mark.final)
  vim.fn.append(first - 1, comment .. M.config.mark.first)
  vim.notify("Context markers added", vim.log.levels.INFO)
end

function M.ask()
  if not M.config.api_key then
    vim.notify("ANTHROPIC_API_KEY missing", vim.log.levels.ERROR)
    return
  end

  -- Combine visual selection with context blocks
  local first, final = M.get_visual_selection()
  local lines = vim.fn.getline(first, final)
  local selection = table.concat(lines, "\n")

  local contexts = M.collect_context()
  local content = contexts .. selection

  vim.notify("Querying Claude...")
  local curl_cmd = {
    "curl", "-s", "-X", "POST",
    "https://api.anthropic.com/v1/messages",
    "-H", "content-type: application/json",
    "-H", "anthropic-version: 2023-06-01",
    "-H", "x-api-key: " .. M.config.api_key,
    "-d", vim.json.encode({
      model = M.config.model,
      max_tokens = 1024,
      system = M.config.system,
      messages = {{ role = "user", content = content }}
    })
  }

  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local response = table.concat(data, "")
        local ok, parsed = pcall(vim.json.decode, response)
        if ok and parsed.content and parsed.content[1] then
          vim.fn.append(final, vim.split(parsed.content[1].text, "\n"))
        else
          vim.notify("Error with Claude: " .. response)
        end
      end
    end
  })
end

vim.keymap.set('v', M.config.keymaps.ask, M.ask)
vim.keymap.set('v', M.config.keymaps.mark, M.mark)

return M
