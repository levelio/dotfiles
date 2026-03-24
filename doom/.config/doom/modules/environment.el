;;; modules/environment.el -*- lexical-binding: t; -*-

(when (memq window-system '(mac ns x))
  (use-package! exec-path-from-shell
    :init
    (setq exec-path-from-shell-arguments '("-l"))
    (setq exec-path-from-shell-variables
          (delete-dups
           (append '("PATH" "MANPATH" "PNPM_HOME" "FNM_MULTISHELL_PATH" "FNM_DIR")
                   (when (boundp 'exec-path-from-shell-variables)
                     exec-path-from-shell-variables))))
    :config
    (exec-path-from-shell-initialize)))
