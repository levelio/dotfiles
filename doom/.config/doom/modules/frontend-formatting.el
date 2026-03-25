;;; modules/frontend-formatting.el -*- lexical-binding: t; -*-

(defun +frontend-project-uses-biome-p ()
  "Return non-nil if current project is configured for Biome."
  (when-let* ((root (or (doom-project-root) default-directory)))
    (or (file-exists-p (expand-file-name "biome.json" root))
        (file-exists-p (expand-file-name "biome.jsonc" root)))))

(defun +frontend-project-uses-eslint-flat-config-p ()
  "Return non-nil if current project uses ESLint flat config."
  (when-let* ((root (or (doom-project-root) default-directory)))
    (or (file-exists-p (expand-file-name "eslint.config.js" root))
        (file-exists-p (expand-file-name "eslint.config.mjs" root))
        (file-exists-p (expand-file-name "eslint.config.cjs" root))
        (file-exists-p (expand-file-name "eslint.config.ts" root))
        (file-exists-p (expand-file-name "eslint.config.mts" root))
        (file-exists-p (expand-file-name "eslint.config.cts" root)))))

(defun +frontend-project-uses-eslint-p ()
  "Return non-nil if current project uses any ESLint config style."
  (when-let* ((root (or (doom-project-root) default-directory)))
    (or (+frontend-project-uses-eslint-flat-config-p)
        (file-exists-p (expand-file-name ".eslintrc" root))
        (file-exists-p (expand-file-name ".eslintrc.js" root))
        (file-exists-p (expand-file-name ".eslintrc.cjs" root))
        (file-exists-p (expand-file-name ".eslintrc.mjs" root))
        (file-exists-p (expand-file-name ".eslintrc.json" root))
        (file-exists-p (expand-file-name ".eslintrc.yaml" root))
        (file-exists-p (expand-file-name ".eslintrc.yml" root)))))

(defun +frontend-eslint-fixable-mode-p ()
  "Return non-nil when the current buffer should be fixed by ESLint."
  (derived-mode-p 'js-mode 'js-ts-mode 'js2-mode
                  'typescript-mode 'typescript-ts-mode
                  'typescript-tsx-mode 'tsx-ts-mode))

(defun +frontend-biome-formattable-mode-p ()
  "Return non-nil when the current buffer should be formatted by Biome."
  (or (+frontend-eslint-fixable-mode-p)
      (derived-mode-p 'css-mode 'css-ts-mode
                      'scss-mode
                      'json-mode 'json-ts-mode)))

(defun +frontend-select-formatter ()
  "Select the appropriate formatter for current buffer."
  (cond
   ((and (+frontend-project-uses-biome-p)
         (+frontend-biome-formattable-mode-p))
    'biome)
   ((and (+frontend-project-uses-eslint-p)
         (+frontend-eslint-fixable-mode-p))
    'eslint-fix)
   (t nil)))

(defun +frontend-setup-formatter-h ()
  "Select a formatter before Doom enables LSP formatting."
  (let ((formatter (+frontend-select-formatter)))
    (setq-local +format-with formatter)
    (when (bound-and-true-p +format-with-lsp-mode)
      (+format-with-lsp-mode -1))))

(after! apheleia
  (require 'apheleia-formatters)

  (setf (alist-get 'eslint-fix apheleia-formatters)
        `("node"
          ,(expand-file-name "bin/eslint-fix-stdin.cjs" doom-user-dir)
          filepath))

  ;; typescript-mode's TSX fallback should use the same formatter chain
  ;; as tree-sitter TSX buffers.
  (setf (alist-get 'typescript-tsx-mode apheleia-mode-alist)
        'eslint-fix))

(dolist (hook '(js-mode-hook js-ts-mode-hook js2-mode-hook
                typescript-mode-hook typescript-ts-mode-hook
                typescript-tsx-mode-hook tsx-ts-mode-hook
                web-mode-hook css-mode-hook css-ts-mode-hook scss-mode-hook
                less-css-mode-hook json-mode-hook json-ts-mode-hook))
  (add-hook hook #'+frontend-setup-formatter-h))
