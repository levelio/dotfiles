;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Import shell PATH/env in GUI Emacs on macOS.
(package! exec-path-from-shell)

;; Fallback major mode when typescript-ts-mode has no tree-sitter grammar.
(package! typescript-mode)

;; Agent Shell - Emacs buffer to interact with LLM agents (Claude Code, Gemini, etc.)
(package! shell-maker)
(package! acp)
(package! agent-shell)
