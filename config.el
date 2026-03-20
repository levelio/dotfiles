;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Identity (optional)
;; (setq user-full-name "Your Name"
;;       user-mail-address "you@example.com")

;; Keep this file small and stable. Module files below carry the actual
;; behavior so they can evolve independently.
(load! "modules/ui")
(load! "modules/environment")
(load! "modules/frontend-modes")
(load! "modules/frontend-formatting")
(load! "modules/frontend-lsp")
(load! "modules/editing")
(load! "modules/agent")
(load! "modules/frontend-checking")
(load! "modules/terminal")
(load! "modules/keybinds")
