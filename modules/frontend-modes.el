;;; modules/frontend-modes.el -*- lexical-binding: t; -*-

(setq-default tab-width 2)

(setq js-indent-level 2
      typescript-indent-level 2
      typescript-ts-mode-indent-offset 2
      css-indent-offset 2)

;; Highlight .env files, including variants like .env.local/.env.production.
(use-package! dotenv-mode
  :mode (("\\.env\\.[^/]+\\'" . dotenv-mode)
         ("\\.env\\'" . dotenv-mode)))

(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

(after! treesit
  (dolist (dir (list (expand-file-name ".local/etc/tree-sitter" user-emacs-directory)
                     (expand-file-name ".local/cache/tree-sitter" user-emacs-directory)))
    (when (file-directory-p dir)
      (add-to-list 'treesit-extra-load-path dir))))

(after! projectile
  (dolist (marker '("pnpm-workspace.yaml" "turbo.json" "lerna.json" "nx.json"))
    (add-to-list 'projectile-project-root-files-bottom-up marker)))
