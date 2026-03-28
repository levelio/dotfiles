;;; modules/ui.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-opera-light
      doom-opera-light-padded-modeline 4
      doom-opera-light-brighter-modeline nil
      display-line-numbers-type 'relative
      org-directory "~/org/")

(defun +ui-setup-modeline-faces-h ()
  (let ((active-bg (doom-lighten (doom-color 'bg) 0.02))
        (inactive-bg (doom-lighten (doom-color 'bg) 0.04)))
    (set-face-attribute 'mode-line nil
                        :background active-bg
                        :foreground (doom-color 'fg)
                        :box nil)
    (when (facep 'mode-line-active)
      (set-face-attribute 'mode-line-active nil
                          :background active-bg
                          :foreground (doom-color 'fg)
                          :box nil))
    (set-face-attribute 'mode-line-inactive nil
                        :background inactive-bg
                        :foreground (doom-color 'fg-alt)
                        :box nil)
    (when (facep 'solaire-mode-line-face)
      (set-face-attribute 'solaire-mode-line-face nil
                          :inherit 'mode-line
                          :background active-bg
                          :box nil))
    (when (facep 'solaire-mode-line-inactive-face)
      (set-face-attribute 'solaire-mode-line-inactive-face nil
                          :inherit 'mode-line-inactive
                          :background inactive-bg
                          :box nil))
    (when (facep 'doom-modeline-bar)
      (set-face-attribute 'doom-modeline-bar nil
                          :background (doom-color 'blue)
                          :foreground (doom-color 'blue)
                          :box nil))
    (when (facep 'doom-modeline-bar-inactive)
      (set-face-attribute 'doom-modeline-bar-inactive nil
                          :inherit 'mode-line-inactive
                          :background inactive-bg
                          :foreground inactive-bg
                          :box nil))
    (dolist (face '(mode-line-highlight
                    doom-modeline-highlight
                    doom-modeline-panel
                    doom-modeline-info
                    doom-modeline-warning
                    doom-modeline-urgent
                    doom-modeline-debug
                    doom-modeline-unread-number
                    doom-modeline-notification))
      (when (facep face)
        (set-face-attribute face nil
                            :background 'unspecified
                            :box nil))))
  (dolist (face '(doom-modeline-buffer-path
                  doom-modeline-buffer-file
                  doom-modeline-buffer-major-mode
                  doom-modeline-project-parent-dir
                  doom-modeline-project-dir
                  doom-modeline-project-root-dir
                  doom-modeline-vcs-default))
    (set-face-attribute face nil :weight 'normal)))

(after! doom-modeline
  (setq doom-modeline-height 28
        doom-modeline-bar-width 4
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-minor-modes nil
        doom-modeline-buffer-encoding nil
        doom-modeline-time nil)
  (+ui-setup-modeline-faces-h)
  (add-hook 'doom-load-theme-hook #'+ui-setup-modeline-faces-h))

(use-package! highlight-indent-guides
  :hook ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?│
        highlight-indent-guides-delay 0.05
        highlight-indent-guides-auto-enabled nil
        highlight-indent-guides-responsive 'top)

  (defun +ui-setup-indent-guide-faces-h ()
    (let ((guide-color (doom-blend 'fg 'bg 0.14))
          (guide-focus-color (doom-blend 'fg 'bg 0.28)))
      (set-face-foreground 'highlight-indent-guides-character-face guide-color)
      (set-face-foreground 'highlight-indent-guides-top-character-face guide-focus-color)
      (set-face-foreground 'highlight-indent-guides-stack-character-face guide-focus-color)))

  (+ui-setup-indent-guide-faces-h)
  (add-hook 'doom-load-theme-hook #'+ui-setup-indent-guide-faces-h))

(use-package! nyan-mode
  :config
  (setq nyan-animate-nyancat nil
        nyan-wavy-trail nil
        nyan-bar-length 16)
  (nyan-mode 1))

(setq fancy-splash-image (expand-file-name "nyancat.png" doom-private-dir))

(add-hook 'window-setup-hook #'toggle-frame-maximized)

(after! magit
  (set-face-attribute 'magit-diff-added-highlight nil
                      :background (doom-blend 'green 'bg 0.1)
                      :foreground (doom-color 'green))
  (set-face-attribute 'magit-diff-removed-highlight nil
                      :background (doom-blend 'red 'bg 0.1)
                      :foreground (doom-color 'red))
  (set-face-attribute 'magit-diff-added nil
                      :background (doom-blend 'green 'bg 0.05)
                      :foreground (doom-color 'green))
  (set-face-attribute 'magit-diff-removed nil
                      :background (doom-blend 'red 'bg 0.05)
                      :foreground (doom-color 'red))
  (set-face-attribute 'magit-diff-context-highlight nil
                      :background (doom-color 'bg-alt))
  (set-face-attribute 'magit-diff-hunk-heading-highlight nil
                      :background (doom-color 'bg-alt)
                      :foreground (doom-color 'fg-alt))
  (setq magit-diff-refine-hunk nil)
  (set-face-attribute 'magit-diff-lines-boundary nil
                      :inherit 'magit-diff-added-highlight)
  (set-face-attribute 'magit-diff-lines-heading nil
                      :background (doom-color 'bg-alt)
                      :foreground (doom-color 'yellow)))

(when (find-font (font-spec :family "JetBrainsMono Nerd Font"))
  (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 18)
        line-spacing 0.4))
