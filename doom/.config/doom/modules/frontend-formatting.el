;;; modules/frontend-formatting.el -*- lexical-binding: t; -*-

(defun +frontend-project-uses-biome-p ()
  "Return non-nil if current project is configured for Biome."
  (when-let* ((root (or (doom-project-root) default-directory)))
    (and (executable-find "biome")
         (or (file-exists-p (expand-file-name "biome.json" root))
             (file-exists-p (expand-file-name "biome.jsonc" root))))))

(defun +frontend-project-uses-eslint-flat-config-p ()
  "Return non-nil if current project uses ESLint flat config."
  (when-let* ((root (or (doom-project-root) default-directory)))
    (or (file-exists-p (expand-file-name "eslint.config.js" root))
        (file-exists-p (expand-file-name "eslint.config.mjs" root))
        (file-exists-p (expand-file-name "eslint.config.cjs" root)))))

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

(defun +frontend-prettier-formatter ()
  "Return the Prettier formatter that best matches the current buffer."
  (cond
   ((derived-mode-p 'typescript-mode 'typescript-ts-mode
                    'typescript-tsx-mode 'tsx-ts-mode)
    'prettier-typescript)
   ((derived-mode-p 'js-mode 'js-ts-mode 'js2-mode)
    'prettier-javascript)
   ((derived-mode-p 'css-mode 'css-ts-mode)
    'prettier-css)
   ((derived-mode-p 'scss-mode)
    'prettier-scss)
   ((derived-mode-p 'json-mode 'json-ts-mode)
    'prettier-json)
   (t 'prettier)))

(defun +frontend-select-formatter ()
  "Select the appropriate formatter for current buffer."
  (let ((prettier (+frontend-prettier-formatter)))
    (cond
     ((+frontend-project-uses-biome-p) 'biome)
     ;; In ESLint-backed JS/TS projects, let ESLint apply autofixes first and
     ;; then let Prettier produce the final layout.
     ((and (+frontend-project-uses-eslint-p)
           (derived-mode-p 'js-mode 'js-ts-mode 'js2-mode
                           'typescript-mode 'typescript-ts-mode
                           'typescript-tsx-mode 'tsx-ts-mode 'web-mode))
      (list 'eslint-fix prettier))
     (t prettier))))

(defun +frontend-setup-formatter-h ()
  "Select a formatter before Doom enables LSP formatting."
  (let ((formatter (+frontend-select-formatter)))
    (setq-local +format-with formatter)
    (when (bound-and-true-p +format-with-lsp-mode)
      (+format-with-lsp-mode -1))))

(after! apheleia
  (require 'apheleia-formatters)

  ;; typescript-mode's TSX fallback should use the same formatter chain
  ;; as tree-sitter TSX buffers.
  (setf (alist-get 'typescript-tsx-mode apheleia-mode-alist)
        'prettier-typescript)

  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))

  (setf (alist-get 'eslint-fix apheleia-formatters)
        '("eslint_d" "--stdin" "--fix-to-stdout" "--stdin-filename" filepath)))

(dolist (hook '(js-mode-hook js-ts-mode-hook js2-mode-hook
                typescript-mode-hook typescript-ts-mode-hook
                typescript-tsx-mode-hook tsx-ts-mode-hook
                web-mode-hook css-mode-hook css-ts-mode-hook scss-mode-hook
                less-css-mode-hook json-mode-hook json-ts-mode-hook))
  (add-hook hook #'+frontend-setup-formatter-h))
