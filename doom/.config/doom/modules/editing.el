;;; modules/editing.el -*- lexical-binding: t; -*-

(after! evil
  (setq evil-escape-key-sequence "kj"
        evil-escape-delay 0.2)
  (define-key evil-insert-state-map [return] #'newline-and-indent))

(after! corfu
  (setq corfu-popupinfo-delay '(0.3 . 0.5)
        corfu-preselect 'first)
  (define-key corfu-map [return] #'corfu-insert))
