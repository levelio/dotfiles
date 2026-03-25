;;; modules/frontend-lsp.el -*- lexical-binding: t; -*-

(defun +frontend-vtsls-workspace-configuration (&optional config)
  "Merge frontend-friendly vtsls settings into CONFIG."
  (let* ((config (copy-tree (or config '())))
         (vtsls (copy-tree (plist-get config :vtsls))))
    (setq vtsls (plist-put vtsls :autoUseWorkspaceTsdk t))
    (setq vtsls (plist-put vtsls :enableMoveToFileCodeAction :json-false))
    (plist-put config :vtsls vtsls)))

(defun +frontend-setup-eglot-workspace-configuration-h ()
  "Configure Eglot workspace settings for frontend buffers."
  (when (boundp 'eglot-workspace-configuration)
    (setq-local eglot-workspace-configuration
                (let ((current eglot-workspace-configuration))
                  (if (functionp current)
                      (lambda (server)
                        (+frontend-vtsls-workspace-configuration
                         (funcall current server)))
                    (+frontend-vtsls-workspace-configuration current))))))

(defun +frontend-eglot-managed-mode-p ()
  "Return non-nil when the current buffer is a frontend Eglot buffer."
  (and (bound-and-true-p eglot--managed-mode)
       (derived-mode-p 'js-mode 'js-ts-mode
                       'typescript-mode 'typescript-ts-mode
                       'typescript-tsx-mode 'tsx-ts-mode)))

(defun +frontend-disable-eglot-code-action-hints-h ()
  "Avoid background code-action requests in frontend buffers.

TypeScript 5.8.x can crash while enumerating certain refactors such as
\"Move to a new file\". Disabling the automatic hint request keeps Eglot from
asking for all code actions on every cursor move."
  (when (+frontend-eglot-managed-mode-p)
    (setq-local eglot-code-action-indications nil)))

(defun +frontend-eglot-safe-code-actions (&optional beg end)
  "Run safer Eglot code actions for frontend buffers.

In TypeScript projects we default to quick fixes, because asking for the full
action list may still trigger buggy refactors in the underlying TypeScript
service."
  (interactive (eglot--code-action-bounds))
  (if (+frontend-eglot-managed-mode-p)
      (eglot-code-actions beg end "quickfix" t)
    (eglot-code-actions beg end nil t)))

(dolist (hook '(js-mode-hook js-ts-mode-hook
                typescript-mode-hook typescript-ts-mode-hook
                typescript-tsx-mode-hook tsx-ts-mode-hook))
  (add-hook hook #'+frontend-setup-eglot-workspace-configuration-h))

(after! eglot
  (setq eglot-send-changes-idle-time 0.3)

  (add-to-list 'eglot-server-programs
               '(((js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript")
                  (tsx-ts-mode :language-id "typescriptreact")
                  (typescript-tsx-mode :language-id "typescriptreact")
                  (typescript-ts-mode :language-id "typescript")
                  (typescript-mode :language-id "typescript"))
                 . ("vtsls" "--stdio"
                    :initializationOptions
                    (:hostInfo "GNU Emacs / Eglot"))))

  (add-hook 'eglot-managed-mode-hook #'+frontend-disable-eglot-code-action-hints-h))
