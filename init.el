;; 设置个人信息
(setq user-full-name "MingxunBai"
      user-mail-address "MingxunBai@outlook.com")

;; 路径配置
(add-to-list 'load-path (expand-file-name "plugins" user-emacs-directory))

(if (eq system-type 'windows-nt)
    (setq default-directory "c:\\xampp\\htdocs"))

;; 编码环境
(setq current-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-8)

;; 显示
(setq inhibit-startup-message t) ; 关闭启动动画

(setq split-height-threshold nil ; 垂直分屏
      split-width-threshold 0)

(setq frame-title-format '("Emacs@%S" (buffer-file-name "%f" (dired-directory dired-directory "%b")))) ; 标题显示完整路径

(global-font-lock-mode t) ; 语法高亮(除了 shell-mode 和 text-mode)
(setq font-lock-maximum-decoration t ; 只渲染当前 buffer 语法高亮
      font-lock-verbose t
      font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))

(global-linum-mode t) ; 显示行号
(setq linum-format "%4d "
      column-number-mode t
      line-number-mode t)

(show-paren-mode t) ; 高亮匹配括号
(setq show-paren-style 'parenthesis) ; 光标不会跳到另一个括号处

(setq scroll-margin 3 scroll-conservatively 10000) ; 靠近屏幕边沿3行时就开始滚动

(scroll-bar-mode -1) ; 隐藏滚动条
(tool-bar-mode -1) ; 隐藏工具栏
(menu-bar-mode -1) ; 隐藏菜单栏

(setq display-time-24hr-format t) ; 24小时制
(display-time) ; 启用时间显示

;; 操作
(setq default-major-mode 'text-mode) ; 设置默认主模式为 text-mode

(setq kill-ring-max 500) ; 设置历史记录数量

(setq inhibit-startup-message t) ; 关闭出错提示音

(setq-default kill-whole-line t) ; 在行首 C-k 时，同时删除该行

(setq track-eol t) ; 当光标在行尾上下移动的时候，始终保持在行尾

(fset 'yes-or-no-p 'y-or-n-p) ; 使用 y/n 替代 yes/no

(setq x-select-enable-clipboard t) ; 支持和外部程序的拷贝

(setq make-backup-files nil ; 不生成备份文件
      auto-save-default nil) ; 不生成临时文件

(global-set-key (kbd "RET") 'newline-and-indent) ; 回车时缩进
(setq-default indent-tabs-mode  nil ; 设置缩进为空格
              tab-width 4) ; 设置默认缩进为 4

;; 启动后最大化
(custom-set-variables
  '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; hs-mode
(global-set-key [f2] 'hs-toggle-hiding)

;; ido-mode
(ido-mode t)
(setq ido-save-directory-list-file nil)

;; org-mode
(add-hook 'org-mode-hook (lambda ()
                           (auto-complete-mode)

                           (setq org-startup-indented t) ; 自动缩进

                           (require 'htmlize)
                           (setq org-src-fontify-natively t) ; 代码高亮

                           (defun org-insert-src-block (src-code-type)
                             (interactive
                              (let ((src-code-types
                                     '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
                                       "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
                                       "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
                                       "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
                                       "scheme" "sqlite" "html")))
                                (list (ido-completing-read "Source code type: " src-code-types))))
                             (progn
                               (newline-and-indent)
                               (insert (format "#+BEGIN_SRC %s\n" src-code-type))
                               (newline-and-indent)
                               (insert "#+END_SRC\n")
                               (previous-line 2)
                               (org-edit-src-code)))

                           (local-set-key (kbd "C-c s e") ; keybinding for editing source code blocks
                                          'org-edit-src-code)
                           (local-set-key (kbd "C-c s i") ; keybinding for inserting code blocks
                                          'org-insert-src-block)))

;; winner-mode
(when (fboundp 'winner-mode)
  (winner-mode 1))
(global-set-key (kbd "C-x 4 u") 'winner-undo)
(global-set-key (kbd "C-x 4 r") 'winner-redo)

;; auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode t)
(add-hook 'text-mode-hook 'auto-complete-mode)
(setq ac-auto-start nil)
(setq ac-use-menu-map t) ; set hot key for menu map
(define-key ac-mode-map "\M-;" 'auto-complete)
(define-key ac-completing-map "\M-;" 'ac-stop)

;; emmet-mode
(defun enable-emmet-mode ()
  (require 'emmet-mode)
  (emmet-mode))

;; highlight-parentheses-mode
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t))) 
(global-highlight-parentheses-mode)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines) ; edit each line in region
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click) ; bind mouse event

;; project-explorer
(require 'project-explorer)
(global-set-key [f1] 'project-explorer-toggle)

;; web-mode
(defun my-web-mode-hook ()
  (web-plugins)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-enable-current-element-highlight t)) ; 高亮所在标签元素
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; windows-numbering
(require 'window-numbering)
(window-numbering-mode 1)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (require 'popup) ; use popup menu for yas-choose-value
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     :isearch t ; start isearch mode immediately
     )))
(setq yas-prompt-functions '(yas-popup-isearch-prompt))

;; 自加载对应模式
(setq auto-mode-alist
      (append '(("\\.html?\\'" . (lambda ()
                                   (require 'web-mode)
                                   (web-mode)))
                ("\\.xml\\'" . web-mode)
                ("\\.svg\\'" . web-mode)
                ("\\.php\\'" . web-mode)
                ("\\.js\\'" . (lambda ()
                                (require 'js2-mode)
                                (js2-mode)))
                ("\\.py\\'" . python-mode))
              auto-mode-alist))

;; web plugins
(defun web-plugins ()
  (hs-minor-mode t)
  (enable-emmet-mode))
(add-hook 'css-mode-hook 'web-plugins)
(add-hook 'html-mode-hook 'web-plugins)
(add-hook 'js2-mode-hook 'web-plugins)
