local function env(name)
  local value = vim.env[name]
  if value and value ~= "" then
    return value
  end
end

local function codex_base_url()
  local url = env("CODEX_BASE_URL") or env("CODEX_API_BASE") or env("OPENAI_BASE_URL") or env("OPENAI_API_BASE")
  if not url then
    vim.notify("Set CODEX_BASE_URL for CodeCompanion", vim.log.levels.WARN, { title = "CodeCompanion" })
    return "https://example.invalid"
  end
  return url:gsub("/+$", "")
end

local function codex_responses_url()
  local url = env("CODEX_RESPONSES_URL")
  if url then
    return url
  end

  local base_url = codex_base_url()
  return base_url:match("/v1$") and (base_url .. "/responses") or (base_url .. "/v1/responses")
end

local function codex_api_key()
  local key = env("CODEX_API_KEY") or env("OPENAI_API_KEY")
  if not key then
    vim.notify("Set CODEX_API_KEY for CodeCompanion", vim.log.levels.WARN, { title = "CodeCompanion" })
  end
  return key or ""
end

local function codex_model()
  return env("CODEX_MODEL") or "gpt-5-mini"
end

local function codex_model_choices()
  local model = codex_model()
  return {
    [model] = {
      formatted_name = model,
      opts = {
        can_manage_context = false,
        can_reason = false,
        has_function_calling = false,
        has_vision = false,
      },
    },
  }
end

local last_codex_error

local function extract_error_message(data)
  if type(data) == "table" then
    if data.status and data.status < 400 then
      return nil
    end
    local message = extract_error_message(data.body or data.stderr or data.message)
    if message and data.status then
      return ("HTTP %s: %s"):format(data.status, message)
    end
    return message
  end

  if type(data) ~= "string" or vim.trim(data) == "" then
    return nil
  end

  local ok, json = pcall(vim.json.decode, data, { luanil = { object = true } })
  if ok and type(json) == "table" then
    if type(json.error) == "table" then
      return json.error.message or vim.inspect(json.error)
    end
    if json.error then
      return tostring(json.error)
    end
    if json.message then
      return tostring(json.message)
    end
  end

  return nil
end

local commit_message_system_prompt = table.concat({
  "You write concise Conventional Commit messages.",
  "Return only the commit message text.",
  "Write the subject and body in Chinese.",
  "Keep Conventional Commit types such as feat, fix, docs, chore in lowercase English.",
  "Keep the subject line under 72 characters.",
  "Add a short body only when it adds useful context.",
  "Do not wrap the response in markdown.",
}, "\n")

local function notify_commit(message, level, opts)
  opts = vim.tbl_extend("force", {
    id = "codecompanion-commit-message",
    title = "AI Commit Message",
  }, opts or {})

  return vim.notify(message, level, opts)
end

local function staged_diff()
  local result = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil, result.stderr ~= "" and result.stderr or "Not inside a git repository"
  end

  local diff = result.stdout or ""
  if vim.trim(diff) == "" then
    return nil, "No staged changes found. Run git add first."
  end

  return diff
end

local function commit_message_user_prompt(diff)
  return "Generate one commit message for this staged git diff:\n\n```diff\n" .. diff .. "\n```"
end

local function clean_commit_message(message)
  message = vim.trim(message or "")
  message = message:gsub("^```[%w_-]*%s*", "")
  message = message:gsub("%s*```$", "")
  return vim.trim(message)
end

local function latest_llm_message(chat)
  local llm_role = require("codecompanion.config").constants.LLM_ROLE

  for i = #chat.messages, 1, -1 do
    local message = chat.messages[i]
    if message.role == llm_role and type(message.content) == "string" and vim.trim(message.content) ~= "" then
      return message.content
    end
  end
end

local function copy_commit_message(message)
  message = clean_commit_message(message)
  if message == "" then
    notify_commit("生成失败：AI 没有返回 commit message", vim.log.levels.WARN, { timeout = 5000 })
    return false
  end

  vim.fn.setreg('"', message)
  local ok, err = pcall(vim.fn.setreg, "+", message)
  if not ok then
    notify_commit("已复制到默认寄存器，但系统剪贴板失败：" .. tostring(err), vim.log.levels.WARN, {
      timeout = 7000,
    })
    return false
  end

  notify_commit("完成：commit message 已复制到剪贴板", vim.log.levels.INFO, { timeout = 3000 })
  return true
end

local function generate_commit_message()
  local diff, err = staged_diff()
  if not diff then
    notify_commit("错误：" .. err, vim.log.levels.WARN, { timeout = 5000 })
    return
  end

  last_codex_error = nil
  notify_commit("进行中：正在生成 commit message...", vim.log.levels.INFO, { timeout = false })

  require("codecompanion.interactions.chat").new({
    auto_submit = true,
    buffer_context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf(), {}),
    hidden = true,
    ignore_system_prompt = true,
    messages = {
      {
        role = "system",
        content = commit_message_system_prompt,
      },
      {
        role = "user",
        content = commit_message_user_prompt(diff),
      },
    },
    callbacks = {
      on_completed = function(chat)
        local message = latest_llm_message(chat)
        if message then
          copy_commit_message(message)
        else
          local message = "错误：commit message 生成失败"
          if last_codex_error then
            message = message .. "：" .. last_codex_error
          end
          notify_commit(message, vim.log.levels.ERROR, { timeout = 9000 })
        end

        vim.schedule(function()
          chat:close()
        end)
      end,
    },
  })
end

return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ac", generate_commit_message, mode = { "n", "t" }, desc = "AI Commit Message" },
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI Add Selection" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        http = {
          codex_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              url = "${url}",
              env = {
                api_key = codex_api_key,
                url = codex_responses_url,
              },
              opts = {
                compaction = false,
                stream = true,
                tools = false,
                vision = false,
              },
              handlers = {
                lifecycle = {
                  on_exit = function(self, data)
                    last_codex_error = extract_error_message(data)
                    if type(data) == "table" and data.status then
                      return require("codecompanion.adapters.http.openai_responses").handlers.lifecycle.on_exit(
                        self,
                        data
                      )
                    end
                  end,
                },
              },
              schema = {
                model = {
                  default = codex_model(),
                  choices = codex_model_choices(),
                },
                ["reasoning.effort"] = {
                  enabled = function()
                    return false
                  end,
                },
                ["reasoning.summary"] = {
                  enabled = function()
                    return false
                  end,
                },
                temperature = {
                  enabled = function()
                    return false
                  end,
                },
                top_p = {
                  enabled = function()
                    return false
                  end,
                },
                verbosity = {
                  enabled = function()
                    return false
                  end,
                },
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "codex_responses",
        },
        inline = {
          adapter = "codex_responses",
        },
        cmd = {
          adapter = "codex_responses",
        },
        background = {
          adapter = "codex_responses",
        },
      },
      prompt_library = {
        ["Commit Message (staged)"] = {
          interaction = "chat",
          description = "Generate a Conventional Commit message from staged changes",
          opts = {
            alias = "commit_auto",
            auto_submit = true,
            is_slash_cmd = true,
          },
          prompts = {
            {
              role = "system",
              content = commit_message_system_prompt,
            },
            {
              role = "user",
              content = function()
                local diff, err = staged_diff()
                if not diff then
                  return err
                end
                return commit_message_user_prompt(diff)
              end,
            },
          },
        },
      },
      display = {
        action_palette = {
          provider = "snacks",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        mode = { "n", "v" },
        { "<leader>a", group = "ai" },
      })
    end,
  },
}
