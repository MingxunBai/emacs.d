;; ------ 设置个人信息 ------
(setq user-full-name "MingxunBai")
(setq user-mail-address "MingxunBai@outlook.com")

(add-to-list 'load-path (expand-file-name "plugins" user-emacs-directory))

;; For my language code setting (UTF-8)
(setq current-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-8)

(setq inhibit-startup-message t) ; 关闭启动动画

(setq kill-ring-max 500) ; 设置历史记录数量

(setq inhibit-startup-message t) ; 关闭出错提示音

;; 标题显示完整路径
(setq frame-title-format  
   '("Emacs@%S" (buffer-file-name "%f"  
    (dired-directory dired-directory "%b"))))  

;; 语法高亮(除了 shell-mode 和 text-mode)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not shell-mode text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))
(setq font-lock-maximum-decoration t) ; 只渲染当前 buffer 语法高亮

;; 显示行号
(global-linum-mode t)
(setq linum-format "%4d ")
(setq column-number-mode t)
(setq line-number-mode t)

(show-paren-mode t)
(setq show-paren-style 'parenthesis) ; 括号匹配时可以高亮显示另外一边的括号，但光标不会跳到另一个括号处

(setq-default kill-whole-line t) ; 在行首 C-k 时，同时删除该行

(setq track-eol t) ; 当光标在行尾上下移动的时候，始终保持在行尾

(setq scroll-margin 3 scroll-conservatively 10000) ; 靠近屏幕边沿3行时就开始滚动

(fset 'yes-or-no-p 'y-or-n-p) ; 使用 y/n 替代 yes/no

(setq x-select-enable-clipboard t) ; 支持和外部程序的拷贝

(setq make-backup-files nil) ; 不生成备份文件
(setq auto-save-default nil) ; 不生成临时文件

(set-scroll-bar-mode nil) ; 隐藏滚动条
(tool-bar-mode -1) ; 隐藏工具栏

(global-set-key (kbd "RET") 'newline-and-indent) ; 回车时缩进
(setq-default indent-tabs-mode  nil) ; 设置缩进为空格

(setq display-time-24hr-format t) ; 24小时制
(display-time) ; 启用时间显示

;; 启动后最大化
(run-with-idle-timer 0 nil 'w32-send-sys-command 61488) ; for Windows
; (defun my-max-window() ; for Linux | OS X
;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;                          '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;                          '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
; (run-with-idle-timer 1 nil 'my-max-window)

;; hs-mode
(add-hook 'web-mode-hook (lambda ()
                           (hs-minor-mode t)))
(global-set-key  [f2] 'hs-toggle-hiding)

;; Ido-mode
(ido-mode t)
(setq ido-save-directory-list-file nil)

;; Org-mode 自动换行和缩进
(setq truncate-lines nil)
(set-fill-column 70)
(setq org-startup-indented t)

;; Auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq tab-always-indent 'complete)
(setq-default ac-auto-start 3)
(setq ac-auto-show-menu 0.2)
(setq-default ac-expand-on-auto-complete nil)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; Emmet-mode
(require 'emmet-mode)
(add-hook 'web-mode-hook (lambda ()
                           (emmet-mode t)))
(add-hook 'css-mode-hook (lambda ()
			   (emmet-mode t)))

;; Highlight-parentheses-mode
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t))) 
(global-highlight-parentheses-mode)

;; Windows numbering
(require 'window-numbering)
(window-numbering-mode 1)

;; Web-mode
(require 'web-mode)
(defun my-web-mode-hook ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; YASnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Completing point by some yasnippet key
(defun yas-ido-expand ()
  "Lets you select (and expand) a yasnippet key"
  (interactive)
  (let ((original-point (point)))
    (while (and
            (not (= (point) (point-min) ))
            (not
             (string-match "[[:space:]\n]" (char-to-string (char-before)))))
      (backward-word 1))
    (let* ((init-word (point))
           (word (buffer-substring init-word original-point))
           (list (yas-active-keys)))
      (goto-char original-point)
      (let ((key (remove-if-not
                  (lambda (s) (string-match (concat "^" word) s)) list)))
        (if (= (length key) 1)
            (setq key (pop key))
          (setq key (ido-completing-read "key: " list nil nil word)))
        (delete-char (- init-word original-point))
        (insert key)
        (yas-expand)))))
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-ido-expand)

;; Use popup menu for yas-choose-value
(require 'popup)
(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
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
     ;; start isearch mode immediately
     :isearch t
     )))
(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

;; 自加载对应模式
(setq auto-mode-alist
      (append '(("\\.html?\\'" . web-mode)
                ("\\.xml\\'" . web-mode)
                ("\\.svg\\'" . web-mode)
                ("\\.js\\'" . web-mode)
                ("\\.php\\'" . web-mode)
                ; ("\\.phtml\\'" . web-mode)
                ; ("\\.djhtml\\'" . web-mode)
                ; ("\\.[agj]sp\\'" . web-mode)
                ; ("\\.as[cp]x\\'" . web-mode)
                ; ("\\.css\\'" . web-mode)
                ("\\.org\\'" . org-mode)
		("\\.md\\'" . org-mode)
		("\\.py\\'" . python-mode))
	      auto-mode-alist))
