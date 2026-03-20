;;; modules/agent.el -*- lexical-binding: t; -*-

(after! agent-shell
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
        agent-shell-anthropic-claude-environment
        (agent-shell-make-environment-variables :inherit-env t)
        agent-shell-session-strategy 'prompt
        agent-shell-prefer-session-resume t))
