;;; modules/environment.el -*- lexical-binding: t; -*-

(when (memq window-system '(mac ns x))
  (use-package! exec-path-from-shell
    :config
    (setq exec-path-from-shell-arguments '("-l"))
    (exec-path-from-shell-initialize)))

(let ((fnm-default-bin (expand-file-name "~/.local/share/fnm/aliases/default/bin")))
  (when (file-directory-p fnm-default-bin)
    (add-to-list 'exec-path fnm-default-bin)
    (setenv "PATH" (concat fnm-default-bin path-separator (getenv "PATH")))))
