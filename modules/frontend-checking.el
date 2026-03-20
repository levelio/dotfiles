;;; modules/frontend-checking.el -*- lexical-binding: t; -*-

(after! flycheck
  (defvar flycheck-javascript-eslint-executable nil
    "The eslint executable for flycheck.")

  (defun my/flycheck-eslint--find-working-directory (_checker)
    "Find the working directory for eslint, including flat config setups."
    (let* ((flat-config-regex "\\`eslint\\.config\\(\\.js\\|\\.mjs\\|\\.cjs\\)?\\'")
           (eslintrc-regex "\\`\\.eslintrc\\(\\.\\(js\\|ya?ml\\|json\\)\\)?\\'"))
      (when buffer-file-name
        (or (locate-dominating-file buffer-file-name "node_modules")
            (locate-dominating-file buffer-file-name ".eslintignore")
            (locate-dominating-file
             (file-name-directory buffer-file-name)
             (lambda (directory)
               (or (> (length (directory-files directory nil flat-config-regex t)) 0)
                   (> (length (directory-files directory nil eslintrc-regex t)) 0))))))))

  (defun my/flycheck-eslint-config-exists-p ()
    "Check whether eslint config exists, including flat config files."
    (let* ((working-dir (flycheck-eslint--find-working-directory 'javascript-eslint))
           (eslint-exec (or flycheck-javascript-eslint-executable
                            (executable-find "eslint_d")
                            (executable-find "eslint"))))
      (when (and working-dir eslint-exec)
        (let ((flat-config-regex "\\`eslint\\.config\\(\\.js\\|\\.mjs\\|\\.cjs\\)?\\'")
              (eslintrc-regex "\\`\\.eslintrc\\(\\.\\(js\\|ya?ml\\|json\\)\\)?\\'"))
          (or (directory-files working-dir nil flat-config-regex t)
              (directory-files working-dir nil eslintrc-regex t))))))

  (advice-add 'flycheck-eslint--find-working-directory :override
              #'my/flycheck-eslint--find-working-directory)
  (advice-add 'flycheck-eslint-config-exists-p :override
              #'my/flycheck-eslint-config-exists-p)

  (flycheck-add-mode 'javascript-eslint 'js-mode)
  (flycheck-add-mode 'javascript-eslint 'js-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-mode 'javascript-eslint 'typescript-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'tsx-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(defun +eslint-setup-flycheck-h ()
  "Prefer eslint_d, then project-local eslint, then global eslint."
  (let* ((root (or (doom-project-root) default-directory))
         (local-eslint (expand-file-name "node_modules/.bin/eslint" root)))
    (setq-local flycheck-javascript-eslint-executable
                (or (executable-find "eslint_d")
                    (when (file-executable-p local-eslint) local-eslint)
                    (executable-find "eslint")))
    (when (derived-mode-p 'typescript-mode 'typescript-ts-mode 'js-mode 'js-ts-mode 'web-mode)
      (message "[ESLint] executable: %s, working-dir: %s"
               flycheck-javascript-eslint-executable
               (flycheck-eslint--find-working-directory 'javascript-eslint)))))

(dolist (hook '(js-mode-hook js-ts-mode-hook
                typescript-mode-hook typescript-ts-mode-hook
                web-mode-hook))
  (add-hook hook #'+eslint-setup-flycheck-h))

(after! flycheck-eglot
  (setq flycheck-eglot-exclusive nil))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (when eglot--managed-mode
              (+eslint-setup-flycheck-h)
              (when (and (derived-mode-p 'js-mode 'js-ts-mode 'typescript-mode
                                         'typescript-ts-mode 'tsx-ts-mode 'web-mode)
                         (flycheck-valid-checker-p 'javascript-eslint)
                         (flycheck-valid-checker-p 'eglot-check))
                (flycheck-add-next-checker 'eglot-check '(warning . javascript-eslint)))
              (flycheck-buffer))))
