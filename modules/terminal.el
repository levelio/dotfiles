;;; modules/terminal.el -*- lexical-binding: t; -*-

(after! vterm
  (add-hook 'vterm-mode-hook #'evil-insert-state)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq buffer-read-only nil)))
  (evil-define-key '(insert normal) vterm-mode-map
    (kbd "RET") #'vterm-send-return
    [return] #'vterm-send-return))
