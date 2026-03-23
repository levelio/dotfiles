;;; modules/keybinds.el -*- lexical-binding: t; -*-

(map! :leader :desc "Agent Shell" "o l" #'agent-shell)
(map! :leader
      :desc "Dirvish here" "o d" #'dirvish-dwim
      :desc "Dirvish sidebar" "o D" #'dirvish-side)
(map! :leader
      :desc "Ibuffer" "b I" #'ibuffer)

(global-set-key [remap list-buffers] #'ibuffer)

(map! :n "C-s" #'save-buffer
      :i "C-s" #'save-buffer)
