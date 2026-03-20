;;; modules/frontend-modes.el -*- lexical-binding: t; -*-

(setq-default indent-tabs-mode nil
              tab-width 2)

(setq js-indent-level 2
      typescript-indent-level 2
      typescript-ts-mode-indent-offset 2
      css-indent-offset 2)

(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode)))

(defun +frontend-ts-grammar-available-p ()
  "Return non-nil when TypeScript tree-sitter grammar is ready."
  (and (fboundp 'treesit-language-available-p)
       (ignore-errors (treesit-language-available-p 'typescript))))

(defun +frontend-tsx-grammar-available-p ()
  "Return non-nil when TSX tree-sitter grammar is ready."
  (and (fboundp 'treesit-language-available-p)
       (ignore-errors (treesit-language-available-p 'tsx))
       (+frontend-ts-grammar-available-p)))

(defun +frontend-ts-mode ()
  "Use typescript-ts-mode when grammar is ready, otherwise typescript-mode."
  (if (and (fboundp 'typescript-ts-mode)
           (+frontend-ts-grammar-available-p))
      (typescript-ts-mode)
    (typescript-mode)))

(defun +frontend-tsx-mode ()
  "Use tsx-ts-mode when grammar is ready, otherwise fall back to web-mode."
  (if (and (fboundp 'tsx-ts-mode)
           (+frontend-tsx-grammar-available-p))
      (tsx-ts-mode)
    (web-mode)))

(add-to-list 'auto-mode-alist '("\\.ts\\'" . +frontend-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . +frontend-tsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . +frontend-tsx-mode))

(with-eval-after-load 'treesit
  (put 'tsx-ts-mode '+tree-sitter '(web-mode tsx)))

(after! projectile
  (dolist (marker '("pnpm-workspace.yaml" "turbo.json" "lerna.json" "nx.json"))
    (add-to-list 'projectile-project-root-files-bottom-up marker)))
