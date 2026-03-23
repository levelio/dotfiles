;;; modules/ui.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-snazzy
      display-line-numbers-type 'relative
      org-directory "~/org/")

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
  (setq nyan-animate-nyancat t
        nyan-wavy-trail t
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
