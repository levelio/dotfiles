;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
       chinese
       ;;japanese
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       (corfu +orderless +icons)  ; in-buffer completion
       vertico             ; minibuffer completion/search

       :ui
       doom
       dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets
       (whitespace +guess +trim)

       :emacs
       (dired +icons)
       electric
       tramp
       undo
       vc

       :term
       shell
       vterm

       :checkers
       syntax

       :tools
       direnv
       editorconfig
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       data
       emacs-lisp
       (graphql +lsp)
       (javascript +lsp)
       (typescript +lsp)
       markdown
       org
       sh
       (web +lsp)

       :config
       (default +bindings +smartparens))
