;;-------------------------------------------------
;; Basic setting
;;-------------------------------------------------

;; 设置个人信息
(setq user-full-name "MingxunBai"
      user-mail-address "mingxunbai@outlook.com")

;; 检测系统
(defconst *Windows* (eq system-type 'windows-nt))

;; 路径配置
(defun add-subdirs-to-load-path (dir)
  "Recursive add directories to `load-path'."
  (let ((default-directory (file-name-as-directory dir)))
    (add-to-list 'load-path dir)
    (normal-top-level-add-subdirs-to-load-path)))
(add-subdirs-to-load-path (expand-file-name "plugins/" user-emacs-directory))

(when *Windows*
  (setq default-directory "D:/Tools/xampp/htdocs"))

;;-------------------------------------------------
;; 编码环境
;;-------------------------------------------------

(setq current-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;;-------------------------------------------------
;; 显示 & 行为
;;-------------------------------------------------

(setq inhibit-startup-message t         ; 关闭启动动画

      visible-bell t                    ; 关闭错误提示音
      ring-bell-function 'ignore save-abbrevs nil

      split-height-threshold nil        ; 垂直分屏
      split-width-threshold 0

      scroll-margin 3                   ; 靠近屏幕边沿3行时就开始滚动
      scroll-conservatively 10000

      font-lock-maximum-decoration t    ; 只渲染当前 buffer 语法高亮
      font-lock-verbose t
      font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000))

      default-major-mode 'text-mode     ; 设置默认主模式为 text-mode

      kill-ring-max 500                 ; 设置历史记录数量

      inhibit-startup-message t         ; 关闭出错提示音

      kill-whole-line t                 ; 在行首 C-k 时，同时删除该行

      track-eol t                       ; 换行时，光标始终保持在行首尾

      x-select-enable-clipboard t       ; 支持和外部程序的拷贝

      make-backup-files nil             ; 不生成备份文件
      auto-save-default nil             ; 不生成临时文件

      indent-tabs-mode nil              ; 设置缩进为空格
      default-tab-width 4               ; 设置默认缩进为 4
      c-basic-offset 4                  ; 修改 C 语言缩进为 4

      max-lisp-eval-depth 10000

      linum-format "%4d "               ; 四位数显示行号
      column-number-mode
      line-number-mode

      show-paren-style 'parenthesis     ; 光标不会跳到另一个括号处

      display-time-24hr-format t

      frame-title-format (list          ; Title 显示完整路径
                          (format "%s %%S: %%j " (system-name))
                          '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(mouse-avoidance-mode 'animate)         ; 光标将鼠标自动弹开
(fset 'yes-or-no-p 'y-or-n-p)           ; 使用 y/n 替代 yes/no

;; 设置字体
;; (set-default-font "Source Code Pro-12")
(when *Windows*                         ; 设置中文字体为 "明兰黑"
  (set-fontset-font t 'han (font-spec :family "Minglan_Code")))

;; 自动匹配
(setq skeleton-pair-alist
      '((?\" _ "\"" >)
        (?\' _ "\'" >)
        (?\( _ ")" >)
        (?\[ _ "]" >)
        (?\{ _ "}" >)
        (?\< _ ">" >))

      skeleton-pair t)

;;-------------------------------------------------
;; Internal mode
;;-------------------------------------------------

(scroll-bar-mode -1)                    ; 隐藏滚动条
(tool-bar-mode -1)                      ; 隐藏工具栏
(menu-bar-mode -1)                      ; 隐藏菜单栏

(global-font-lock-mode)                 ; 语法高亮

(show-paren-mode)                       ; 高亮匹配括号

(global-linum-mode)                     ; 显示行号

(display-time)                          ; 显示时间

;; Highlight line mode
(global-hl-line-mode)

(set-face-attribute hl-line-face nil :underline t)

;; Ido mode
(ido-mode)

(setq ido-save-directory-list-file nil
      ido-enable-flex-matching t)       ; 模糊匹配

;; Winner mode
(when (fboundp 'winner-mode)
  (winner-mode))

;;-------------------------------------------------
;; Custom function
;;-------------------------------------------------

;; 自定缩进
(defun custom-resize-indentation (n)
  (interactive "nEnter indentation size:")
  (if (use-region-p)
      (let (mark (mark))
        (save-excursion
          (save-match-data
            (indent-rigidly
             (region-beginning)
             (region-end)
             n)
            (push-mark mark t t)
            (setq deactivate-mark nil))))
    (indent-rigidly
     (line-beginning-position)
     (line-end-position)
     n)))

;; 删除空白字符至上一行末尾
(defun custom-delete-whitespace-to-upline ()
  (interactive)
  (progn
    (delete-indentation)
    (indent-according-to-mode)))

;; 向上新建一行
(defun custom-up-newline ()
  (interactive)
  (progn
    (beginning-of-line)
    (newline-and-indent)
    (previous-line)
    (indent-according-to-mode)))

;; 向下新建一行
(defun custom-down-newline ()
  (interactive)
  (progn
    (end-of-line)
    (newline-and-indent)))

;; 在右侧新建一个窗口
(defun custom-new-right-window ()
  (interactive)
  (split-window-right)
  (other-window 1))

;;-------------------------------------------------
;; Extension
;;-------------------------------------------------

;; Auto complete mode
(require 'auto-complete-config)
(global-auto-complete-mode)

(add-to-list 'ac-dictionary-directories (expand-file-name "plugins/auto-complete/dict" user-emacs-directory))
(ac-config-default)
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil
      ac-use-menu-map t)

;; Emmet mode
(defun enable-emmet-mode ()
  (interactive)
  (require 'emmet-mode)
  (emmet-mode))

;; Highlight indent guides
(require 'highlight-indent-guides)

(setq highlight-indent-guides-method 'character)

;; Highlight parentheses mode
(require 'highlight-parentheses)
(highlight-parentheses-mode)

;; History
(require 'history)

;; JavaScript IDE mode
(defun enable-js2-mode ()
  (interactive)
  (require 'js2-mode)
  (js2-mode))

;; Lazy set key
(require 'lazy-set-key)
(require 'lazy-key-bind)

;; Markdown mode
(defun enable-markdown-mode ()
  (interactive)
  (require 'markdown-mode)
  (markdown-mode)

  (when *Windows*                   ; set markdown-command for windows
    (custom-set-variables '(markdown-command "markdown.pl"))))

;; Multiple cursors
(require 'multiple-cursors)

;; Project explorer
(require 'project-explorer)

;; Web mode
(defun enable-web-mode ()
  (interactive)
  (require 'web-mode)
  (web-mode)

  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 4
        web-mode-enable-current-element-highlight t))

;; Windows numbering
(require 'window-numbering)
(window-numbering-mode)

;; Yaml mode
(defun enable-yaml-mode ()
  (interactive)
  (require 'yaml-mode)
  (yaml-mode))

;; YASnippet
(require 'yasnippet)
(yas-global-mode)

;; completing point by some yasnippet key
(defun yas-ido-expand ()
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

;;-------------------------------------------------
;; 主模式
;;-------------------------------------------------

(setq auto-mode-alist
      (append '(("\\.md\\'" . (lambda ()
                                (enable-markdown-mode)))
                ("\\.php\\'" . (lambda ()
                                 (enable-web-mode)))
                ("\\.py\\'" . python-mode)
                ("\\.ya?ml\\'" . (lambda ()
                                   (enable-yaml-mode))))
              auto-mode-alist))

;;-------------------------------------------------
;; Hook
;;-------------------------------------------------

;; Elisp mode
(add-hook 'emacs-lisp-mode-hook '(lambda ()
                                   (setq skeleton-pair-alist
                                         '((?\' "" >)))))

;; JavaScript IDE
(add-hook 'js-mode-hook 'enable-js2-mode)
(add-hook 'js2-mode-hook 'my-web-dev-hook)

;; Org mode
(defun my-org-mode-hook ()
  ;; 禁止 [ 自动补齐
  (setq skeleton-pair-alist
        '((?\[ "" >)))

  (setq org-startup-indented t)         ; 自动缩进

  ;; 代码高亮
  (require 'htmlize)
  (setq org-src-fontify-natively t)

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
      (insert (format "#+BEGIN_SRC %s\n" src-code-type))
      (newline-and-indent)
      (insert "#+END_SRC")
      (previous-line 2)
      (org-edit-src-code))))

(add-hook 'org-mode-hook 'my-org-mode-hook)

;; Python mode
(defun my-python-mode-hook ()
  (interactive)
  (require 'elpy)
  (elpy-mode)

  (highlight-indent-guides-mode)

  (require 'py-autopep8)
  (py-autopep8-enable-on-save)

  (lazy-unset-key '("<backtab>") python-mode-map)

  (setq python-shell-prompt-detect-enabled nil))

(add-hook 'python-mode-hook 'my-python-mode-hook)

;; Web mode
(defun my-web-mode-hook ()
  ;; 禁止 < 自动补齐
  (setq skeleton-pair-alist
        '((?\< "" >)))

  (enable-emmet-mode)
  (hs-minor-mode))

(add-hook 'css-mode-hook 'enable-web-mode)
(add-hook 'html-mode-hook 'enable-web-mode)
(add-hook 'nxml-mode-hook 'enable-web-mode)
(add-hook 'web-mode-hook 'my-web-mode-hook)

;; 配置五笔输入法
(require 'chinese-wbim-extra)

(autoload 'chinese-wbim-use-package "chinese-wbim" "Another emacs input method")
(register-input-method "chinese-wbim" "euc-cn" 'chinese-wbim-use-package "五笔" "汉字五笔输入法" "wb.txt")
(setq chinese-wbim-use-tooltip nil)     ; Tooltip 暂时还不好用

(progn                                  ; 启动五笔输入法
  (interactive)
  (set-input-method 'chinese-wbim)
  (toggle-input-method))

;; 保存前删除多余空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 最大化
(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized)))))
