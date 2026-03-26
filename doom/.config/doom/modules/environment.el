;;; modules/environment.el -*- lexical-binding: t; -*-

(when (memq window-system '(mac ns x))
  (use-package! exec-path-from-shell
    :init
    (setq exec-path-from-shell-arguments '("-l"))
    (setq exec-path-from-shell-variables
          (delete-dups
           (append '("PATH" "MANPATH" "PNPM_HOME" "FNM_DIR")
                   (when (boundp 'exec-path-from-shell-variables)
                     exec-path-from-shell-variables))))
    :config
    (exec-path-from-shell-initialize)
    ;; fnm uses a session-specific multishell symlink that may not exist in
    ;; subprocesses. Add the stable default alias path as a fallback so that
    ;; node/npm/npx are always found (e.g. by Flycheck or LSP servers).
    (let ((fnm-default (expand-file-name "~/.local/share/fnm/aliases/default/bin")))
      (when (file-directory-p fnm-default)
        (add-to-list 'exec-path fnm-default)
        (setenv "PATH" (concat fnm-default ":" (getenv "PATH")))))))
