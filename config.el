;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Identity (optional)
;; (setq user-full-name "Your Name"
;;       user-mail-address "you@example.com")

;; UI
(setq doom-theme 'doom-snazzy
      display-line-numbers-type t
      org-directory "~/org/")

;; 自定义 ASCII banner 函数（新 :ui dashboard 模块）
;; 注意：这个函数需要返回一个字符串，而不是直接插入 buffer
(defun my-dashboard-ascii-banner-fn ()
  "Return custom ASCII banner string with colors from banner.txt."
  (let ((banner-file (expand-file-name "banner.txt" doom-private-dir)))
    (if (file-exists-p banner-file)
        (with-temp-buffer
          (insert-file-contents banner-file)
          (buffer-string))
      nil)))

;; 设置自定义 ASCII banner 函数
(setq +dashboard-ascii-banner-fn #'my-dashboard-ascii-banner-fn)

;; 禁用图片 splash，强制使用 ASCII banner
(setq fancy-splash-image nil)

;; 启动时全屏
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; Magit diff 颜色适配主题
(after! magit
  ;; 使用主题颜色替代 magit 默认的 diff 颜色
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
  ;; 关闭 word-diff 高亮，提升可读性
  (setq magit-diff-refine-hunk nil)
  ;; 如果只想保留选中行的高亮，降低对比度
  (set-face-attribute 'magit-diff-lines-boundary nil
                      :inherit 'magit-diff-added-highlight)
  (set-face-attribute 'magit-diff-lines-heading nil
                      :background (doom-color 'bg-alt)
                      :foreground (doom-color 'yellow)))

;; Font with larger size and line spacing.
(when (find-font (font-spec :family "JetBrainsMono Nerd Font"))
  (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 18)
        line-spacing 0.2))

;; Keep PATH in sync with your login shell on macOS GUI Emacs.
(when (memq window-system '(mac ns x))
  (use-package! exec-path-from-shell
    :config
    (setq exec-path-from-shell-arguments '("-l"))
    (exec-path-from-shell-initialize)))

;; Ensure fnm default Node toolchain is always reachable in GUI Emacs.
(let ((fnm-default-bin (expand-file-name "~/.local/share/fnm/aliases/default/bin")))
  (when (file-directory-p fnm-default-bin)
    (add-to-list 'exec-path fnm-default-bin)
    (setenv "PATH" (concat fnm-default-bin path-separator (getenv "PATH")))))

;; Frontend defaults: 2 spaces and no tabs.
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

;; Keep TS/TSX/JSX usable even when tree-sitter grammars are missing.
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
  ;; Default Doom fallback for tsx-ts-mode can be nil; enforce a sane fallback.
  (put 'tsx-ts-mode '+tree-sitter '(web-mode tsx)))

;; Recognize common monorepo root markers.
(after! projectile
  (dolist (marker '("pnpm-workspace.yaml" "turbo.json" "lerna.json" "nx.json"))
    (add-to-list 'projectile-project-root-files-bottom-up marker)))

;; Prefer Biome in Biome projects, otherwise use Prettier.
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

(defun +frontend-select-formatter ()
  "Select the appropriate formatter for current buffer."
  (cond
   ((+frontend-project-uses-biome-p) 'biome)
   ((+frontend-project-uses-eslint-flat-config-p) 'eslint-fix)
   (t 'prettier)))

(defun +frontend-setup-formatter-h ()
  "Set the formatter for JS/TS/Web buffers.
This must run BEFORE Doom's +format-with-lsp-toggle-h to prevent LSP override."
  (let ((formatter (+frontend-select-formatter)))
    ;; 设置 +format-with（apheleia-formatter 的别名）
    ;; 这会阻止 Doom 的 +format-with-lsp-toggle-h 启用 LSP 格式化
    (setq-local +format-with formatter)
    ;; 禁用 LSP 格式化模式（如果已激活）
    (when (bound-and-true-p +format-with-lsp-mode)
      (+format-with-lsp-mode -1))))

;; 在 apheleia 加载后注册格式化器
(after! apheleia
  (require 'apheleia-formatters)

  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))

  ;; 添加 eslint_d 格式化器（支持 --fix-to-stdout）
  (setf (alist-get 'eslint-fix apheleia-formatters)
        '("eslint_d" "--stdin" "--fix-to-stdout" "--stdin-filename" filepath)))

;; 在 major mode hook 中设置格式化器（在 eglot 连接之前）
;; 这样 Doom 的 +format-with-lsp-toggle-h 就不会覆盖我们的设置
(dolist (hook '(js-mode-hook js-ts-mode-hook js2-mode-hook
                typescript-mode-hook typescript-ts-mode-hook tsx-ts-mode-hook
                web-mode-hook css-mode-hook css-ts-mode-hook scss-mode-hook
                less-css-mode-hook json-mode-hook json-ts-mode-hook))
  (add-hook hook #'+frontend-setup-formatter-h))

;; Eglot tuning for smoother large frontend projects.
(after! eglot
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.3)

  ;; 为 web-mode (JSX/Vue) 启用 eglot
  (add-to-list 'eglot-server-programs
               '((web-mode :language-id "typescriptreact")
                 . ("typescript-language-server" "--stdio")))

  ;; 自动在 web-mode 中启动 eglot
  (add-hook 'web-mode-hook
            (lambda ()
              (when (or (string-suffix-p ".jsx" (buffer-file-name))
                        (string-suffix-p ".tsx" (buffer-file-name)))
                (eglot-ensure))))

  ;; 自动在 typescript-mode 和 typescript-ts-mode 中启动 eglot
  (dolist (hook '(typescript-mode-hook typescript-ts-mode-hook))
    (add-hook hook 'eglot-ensure)))

;; Use "kj" to escape insert mode (like jk/kj in Vim).
(after! evil
  (setq evil-escape-key-sequence "kj"
        evil-escape-delay 0.2))

;; Fix RET to auto-indent in insert mode.
(after! evil
  (define-key evil-insert-state-map [return] 'newline-and-indent))

;; Corfu popupinfo - 在补全菜单旁显示文档
(after! corfu
  (setq corfu-popupinfo-delay '(0.3 . 0.5)
        corfu-popupinfo-hide nil
        ;; 预选第一个候选项
        corfu-preselect t)

  ;; RET 在补全菜单中插入当前候选项
  (define-key corfu-map [return] #'corfu-insert))

;; Agent Shell - LLM agents 交互
(after! agent-shell
  ;; Evil 模式键绑定：insert 模式 RET 换行，normal 模式 RET 发送
  (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
  (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)

  ;; Tab 展开/折叠当前元素
  (evil-define-key '(insert normal) agent-shell-mode-map (kbd "TAB") #'agent-shell-ui-toggle-fragment-at-point)
  (evil-define-key '(insert normal) agent-shell-mode-map (kbd "<tab>") #'agent-shell-ui-toggle-fragment-at-point)

  ;; diff buffer 使用 Emacs state，方便 y/n/p/q 操作
  (add-hook 'diff-mode-hook
            (lambda ()
              (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
                (evil-emacs-state))))

  ;; 使用 login 认证（Claude Code 默认）
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))

  ;; 继承父进程的环境变量（如 PATH 等）
  (setq agent-shell-anthropic-claude-environment
        (agent-shell-make-environment-variables :inherit-env t))

  ;; 会话策略：prompt 模式，启动时选择恢复或新建会话
  (setq agent-shell-session-strategy 'prompt
        agent-shell-prefer-session-resume t))

;; 快捷键：SPC o l 打开 agent-shell
(map! :leader :desc "Agent Shell" "o l" #'agent-shell)

;; Ctrl+s 保存当前 buffer
(map! :n "C-s" #'save-buffer
      :i "C-s" #'save-buffer)

;; Flycheck/ESLint - 同时使用 LSP 和 ESLint
(after! flycheck
  ;; 定义 flycheck-javascript-eslint-executable 变量（如果尚未定义）
  (defvar flycheck-javascript-eslint-executable nil
    "The eslint executable for flycheck.")

  ;; 覆盖 flycheck 的 eslint 工作目录查找函数，支持 flat config
  (defun my/flycheck-eslint--find-working-directory (checker)
    "Look for a working directory to run ESLint CHECKER in.
Supports both .eslintrc and eslint.config.js (flat config)."
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

  (advice-add 'flycheck-eslint--find-working-directory :override
              #'my/flycheck-eslint--find-working-directory)

  ;; 覆盖 flycheck-eslint-config-exists-p 以支持 flat config
  (defun my/flycheck-eslint-config-exists-p ()
    "Check if ESLint config exists, supporting both .eslintrc and flat config."
    (let* ((working-dir (flycheck-eslint--find-working-directory 'javascript-eslint))
           (eslint-exec (or flycheck-javascript-eslint-executable
                            (executable-find "eslint_d")
                            (executable-find "eslint"))))
      (when (and working-dir eslint-exec)
        ;; 检查是否存在配置文件
        (let ((flat-config-regex "\\`eslint\\.config\\(\\.js\\|\\.mjs\\|\\.cjs\\)?\\'")
              (eslintrc-regex "\\`\\.eslintrc\\(\\.\\(js\\|ya?ml\\|json\\)\\)?\\'"))
          (or (directory-files working-dir nil flat-config-regex t)
              (directory-files working-dir nil eslintrc-regex t))))))

  (advice-add 'flycheck-eslint-config-exists-p :override
              #'my/flycheck-eslint-config-exists-p)

  ;; 确保 ESLint checker 在 JS/TS 文件中启用
  (flycheck-add-mode 'javascript-eslint 'js-mode)
  (flycheck-add-mode 'javascript-eslint 'js-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-mode 'javascript-eslint 'typescript-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'tsx-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode))

;; 使用 project-local eslint_d（更快，支持守护进程）
(defun +eslint-setup-flycheck-h ()
  "Setup ESLint checker for current buffer using eslint_d or local eslint."
  (let* ((root (or (doom-project-root) default-directory))
         (local-eslint (expand-file-name "node_modules/.bin/eslint" root)))
    ;; 优先使用 eslint_d（全局），其次使用项目本地 eslint
    (setq-local flycheck-javascript-eslint-executable
                (or (executable-find "eslint_d")
                    (when (file-executable-p local-eslint) local-eslint)
                    (executable-find "eslint")))
    ;; 调试信息
    (when (derived-mode-p 'typescript-mode 'typescript-ts-mode 'js-mode 'js-ts-mode 'web-mode)
      (message "[ESLint] executable: %s, working-dir: %s"
               flycheck-javascript-eslint-executable
               (flycheck-eslint--find-working-directory 'javascript-eslint)))))

(add-hook 'js-mode-hook #'+eslint-setup-flycheck-h)
(add-hook 'js-ts-mode-hook #'+eslint-setup-flycheck-h)
(add-hook 'typescript-mode-hook #'+eslint-setup-flycheck-h)
(add-hook 'typescript-ts-mode-hook #'+eslint-setup-flycheck-h)
(add-hook 'web-mode-hook #'+eslint-setup-flycheck-h)

;; flycheck-eglot 配置：允许同时使用其他 checker（如 ESLint）
;; 默认情况下 flycheck-eglot-exclusive 为 t，会阻止其他 checker 运行
(after! flycheck-eglot
  (setq flycheck-eglot-exclusive nil))

;; 在 eglot 连接后链式添加 ESLint checker
;; flycheck-eglot 创建的 checker 名称为 'eglot-check
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (when eglot--managed-mode
              ;; 设置 eslint executable
              (+eslint-setup-flycheck-h)
              ;; 为 JS/TS 文件添加 ESLint checker 链
              (when (and (derived-mode-p 'js-mode 'js-ts-mode 'typescript-mode
                                         'typescript-ts-mode 'tsx-ts-mode 'web-mode)
                         (flycheck-valid-checker-p 'javascript-eslint)
                         (flycheck-valid-checker-p 'eglot-check))
                ;; 将 ESLint 作为 eglot-check 之后的 checker
                (flycheck-add-next-checker 'eglot-check '(warning . javascript-eslint)))
              ;; 强制重新检查
              (flycheck-buffer))))

;; Vterm 配置：确保 vterm buffer 不是 read-only，并处于 insert state
(after! vterm
  ;; vterm 启动时进入 insert state（evil-mode）
  (add-hook 'vterm-mode-hook #'evil-insert-state)
  ;; 确保 vterm buffer 不是 read-only
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq buffer-read-only nil)))
  ;; 修复 RET 键：使用 evil-define-key 确保覆盖全局的 evil-insert-state-map 绑定
  ;; vterm 中 RET 应该执行命令而不是换行
  (evil-define-key '(insert normal) vterm-mode-map
    (kbd "RET") #'vterm-send-return
    [return] #'vterm-send-return))
