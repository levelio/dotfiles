;;; modules/files.el -*- lexical-binding: t; -*-

(after! ibuffer
  (setq ibuffer-expert t
        ibuffer-show-empty-filter-groups nil
        ibuffer-default-sorting-mode 'alphabetic
        ibuffer-formats
        '((mark modified read-only locked " "
                (name 35 35 :left :elide) " "
                (size 9 -1 :right) " "
                (mode 18 18 :left :elide) " "
                filename-and-process)))

  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Dired" (derived-mode . dired-mode))
           ("Magit" (or (name . "^\\*magit")
                        (derived-mode . magit-mode)))
           ("Org" (derived-mode . org-mode))
           ("Shell" (or (mode . shell-mode)
                        (mode . eshell-mode)
                        (mode . term-mode)
                        (mode . vterm-mode)))
           ("Emacs" (or (name . "^\\*scratch\\*$")
                        (name . "^\\*Messages\\*$")
                        (name . "^\\*Warnings\\*$")
                        (name . "^\\*Help\\*$")
                        (name . "^\\*Backtrace\\*$")))
           ("Config" (filename . "/\\.config/doom/"))
           ("Code" (derived-mode . prog-mode))
           ("Text" (or (derived-mode . text-mode)
                       (mode . markdown-mode)))
           ("Special" (name . "^\\*")))))

  (defun +ibuffer-setup-h ()
    (ibuffer-switch-to-saved-filter-groups "default")
    (unless (eq ibuffer-sorting-mode 'alphabetic)
      (ibuffer-do-sort-by-alphabetic)))

  (add-hook 'ibuffer-mode-hook #'+ibuffer-setup-h)
  (map! :map ibuffer-mode-map
        :n "q" #'quit-window
        :n "gr" #'ibuffer-update
        :n "/" #'ibuffer-filter-by-name
        :n "s n" #'ibuffer-do-sort-by-alphabetic
        :n "s m" #'ibuffer-do-sort-by-major-mode
        :n "s s" #'ibuffer-do-sort-by-size
        :n "g r" #'ibuffer-switch-to-saved-filter-groups))

(after! dired
  (setq delete-by-moving-to-trash t
        dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t
        dired-mouse-drag-files t
        mouse-drag-and-drop-region-cross-program t
        insert-directory-program
        (or (executable-find "gls") insert-directory-program)
        dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  (put 'dired-find-alternate-file 'disabled nil))

(use-package! dirvish
  :init
  (dirvish-override-dired-mode)
  :config
  (setq dirvish-mode-line-bar-image-width 0
        dirvish-use-header-line 'global
        dirvish-header-line-height '(25 . 35)
        dirvish-mode-line-height 24
        dirvish-header-line-format '(:left (path) :right (free-space))
        dirvish-mode-line-format
        '(:left (sort file-time " " file-size symlink)
          :right (omit yank index))
        dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse file-time file-size)
        dirvish-side-attributes
        '(vc-state subtree-state nerd-icons collapse)
        dirvish-side-width 32
        dirvish-side-auto-expand t
        dirvish-side-header-line-format '(:left (project)))
  (setopt dirvish-quick-access-entries
          `(("h" "~/" "Home")
            ("d" "~/Downloads/" "Downloads")
            ("c" ,doom-private-dir "Doom config")
            ("o" ,org-directory "Org")))
  (when (executable-find "fd")
    (setq dirvish-large-directory-threshold 20000))
  (dirvish-side-follow-mode 1)
  (setq mouse-1-click-follows-link nil)
  (define-key dirvish-mode-map (kbd "<mouse-1>") #'dirvish-subtree-toggle-or-open)
  (define-key dirvish-mode-map (kbd "<mouse-2>") #'dired-mouse-find-file-other-window)
  (define-key dirvish-mode-map (kbd "<mouse-3>") #'dired-mouse-find-file)
  (map! :map dirvish-mode-map
        :n "?" #'dirvish-dispatch
        :n "a" #'dirvish-setup-menu
        :n "f" #'dirvish-file-info-menu
        :n "h" #'dired-up-directory
        :n "l" #'dired-find-file
        :n "o" #'dirvish-quick-access
        :n "s" #'dirvish-quicksort
        :n "r" #'dirvish-history-jump
        :n "L" #'dirvish-ls-switches-menu
        :n "v" #'dirvish-vc-menu
        :n "*" #'dirvish-mark-menu
        :n "y" #'dirvish-yank-menu
        :n "N" #'dirvish-narrow
        :n "^" #'dirvish-history-last
        :n "TAB" #'dirvish-subtree-toggle
        :n "M-f" #'dirvish-history-go-forward
        :n "M-b" #'dirvish-history-go-backward
        :n "M-e" #'dirvish-emerge-menu))
