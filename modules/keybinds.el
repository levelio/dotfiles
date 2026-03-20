;;; modules/keybinds.el -*- lexical-binding: t; -*-

(map! :leader :desc "Agent Shell" "o l" #'agent-shell)

(map! :n "C-s" #'save-buffer
      :i "C-s" #'save-buffer)
