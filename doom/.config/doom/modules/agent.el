;;; modules/agent.el -*- lexical-binding: t; -*-

(after! agent-shell
  (let* ((claude-agent-acp-command (or (executable-find "claude-agent-acp")
                                       "claude-agent-acp"))
         (claude-agent-acp-bin (when (file-name-absolute-p claude-agent-acp-command)
                                 (file-name-directory claude-agent-acp-command)))
         (node-command (executable-find "node"))
         (node-bin (when node-command
                     (file-name-directory node-command)))
         (agent-shell-path
          (mapconcat #'identity
                     (delete-dups
                      (delq nil
                            (append (list node-bin claude-agent-acp-bin)
                                    (split-string (or (getenv "PATH") "") path-separator t))))
                     path-separator)))
    (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
    (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)
    (evil-define-key '(insert normal) agent-shell-mode-map
      (kbd "TAB") #'agent-shell-ui-toggle-fragment-at-point
      (kbd "<tab>") #'agent-shell-ui-toggle-fragment-at-point)

    (add-hook 'diff-mode-hook
              (lambda ()
                (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
                  (evil-emacs-state))))

    (setq agent-shell-anthropic-authentication
          (agent-shell-anthropic-make-authentication :login t)
          agent-shell-anthropic-claude-acp-command
          (list claude-agent-acp-command)
          agent-shell-anthropic-claude-environment
          (agent-shell-make-environment-variables
           "PATH" agent-shell-path
           :inherit-env t)
          agent-shell-session-strategy 'prompt
          agent-shell-prefer-session-resume t)))
