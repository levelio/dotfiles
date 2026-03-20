;;; modules/frontend-lsp.el -*- lexical-binding: t; -*-

(after! eglot
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.3)

  (add-to-list 'eglot-server-programs
               '((web-mode :language-id "typescriptreact")
                 . ("typescript-language-server" "--stdio")))

  (add-hook 'web-mode-hook
            (lambda ()
              (when (and buffer-file-name
                         (or (string-suffix-p ".jsx" buffer-file-name)
                             (string-suffix-p ".tsx" buffer-file-name)))
                (eglot-ensure))))

  (dolist (hook '(typescript-mode-hook typescript-ts-mode-hook))
    (add-hook hook #'eglot-ensure)))
