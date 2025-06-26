local M = {}

M.config = {
    api_key = os.getenv("ANTHROPIC_API_KEY"),
}

function M.ask_claude()
  -- Check API key
  if not M.config.api_key then
    vim.notify("ANTHROPIC_API_KEY not set")
    return
  end

  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines == 0 then return end
  local selection = table.concat(lines, "\n")

  -- Loading message
  vim.api.nvim_echo({{" Querying Claude...", "ModeMsg"}}, false, {})

  -- Prepare API request
  local curl_cmd = {
    "curl", "-s", "-X", "POST",
    "https://api.anthropic.com/v1/messages",
    "-H", "content-type: application/json",
    "-H", "anthropic-version: 2023-06-01",
    "-H", "x-api-key: " .. M.config.api_key,
    "-d", vim.json.encode({
      model = "claude-3-5-sonnet-latest",
      max_tokens = 1024,
      system = "Be concise and direct in your responses. Respond without unnecessary explanation.",
      messages = {{
        role = "user",
        content = selection
      }}
    })
  }
  
  -- Execute request
  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local response = table.concat(data, "")
        local ok, parsed = pcall(vim.json.decode, response)
        
        if ok and parsed.content and parsed.content[1] then
          local claude_response = parsed.content[1].text
          local response_lines = vim.split(claude_response, "\n")
          
          -- Insert response after selection
          vim.fn.append(end_pos[2], response_lines)

          -- Clear loading indicator
          vim.api.nvim_echo({{""}}, false, {})

        elseif ok and parsed.error then
          vim.notify("Claude API Error: " .. (parsed.error.message or "Unknown error"))
        else
          vim.notify("Error parsing Claude response: " .. response)
        end
      end
    end
  })
end

-- Call function on visual selection
vim.api.nvim_set_keymap(
    "v", "<leader>c", ":lua require('claude').ask_claude()<CR>",
    { noremap = true, silent = true }
)

return M
