;;; modules/frontend-lsp.el -*- lexical-binding: t; -*-

(after! eglot
  (setq eglot-send-changes-idle-time 0.3)

  (add-to-list 'eglot-server-programs
               '((typescript-tsx-mode :language-id "typescriptreact")
                 . ("typescript-language-server" "--stdio")))

  (add-to-list 'eglot-server-programs
               '((web-mode :language-id "typescriptreact")
                 . ("typescript-language-server" "--stdio"))))
