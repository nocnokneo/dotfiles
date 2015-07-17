;;
;;  .emacs configuration file
;;
;;  Author: Taylor Braun-Jones
;;

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(browse-url-browser-function (quote browse-url-gnome-moz))
 '(case-fold-search t)
 '(column-number-mode t)
 '(compilation-scroll-output t)
 '(compilation-window-height 15)
 '(compile-command (format tcl-compile-command buffer-file-name))
 '(current-language-environment "ASCII")
 '(fill-column 78)
 '(focus-follows-mouse nil)
 '(global-font-lock-mode t nil (font-lock))
 '(highlight-wrong-size-font nil t)
 '(highline-selected-window t)
 '(indent-tabs-mode nil)
 '(initial-scratch-message nil)
 '(query-replace-highlight t)
 '(scroll-bar-mode (quote right))
 '(scroll-conservatively 10)
 '(scroll-margin 1)
 '(scroll-preserve-screen-position t)
 '(search-highlight t)
 '(show-paren-mode t nil (paren))
 '(tab-always-indent t)
 '(tab-width 8)
 '(transient-mark-mode t))

;; Allow positioning the cursor with a mouse click, and scrolling the buffer
;; using the mouse wheel
(mouse-wheel-mode t)
(xterm-mouse-mode t)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "pale goldenrod" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(font-lock-builtin-face ((((class color) (background light)) (:foreground "medium purple"))))
 '(font-lock-constant-face ((((class color) (background light)) (:foreground "medium slate blue"))))
 '(font-lock-string-face ((((class color) (background light)) (:foreground "forest green"))))
 '(font-lock-type-face ((((class color) (background light)) (:foreground "dodger blue"))))
 '(font-lock-variable-name-face ((((class color) (background light)) (:foreground "sienna"))))
 '(region ((((class color) (background dark)) (:background "DarkOliveGreen4")))))

;; Tell emacs which package to use depending on suffix
(setq auto-mode-alist
      (append '(("\\.\(cc\|C\|c\|hxx\|hpp\|txx\|h\|cpp\|cxx\|cu\|cuh\)$" . c++-mode)
                ("[Mm]akefile" . makefile-mode)
                ("\\.pde$" . c-mode)
                ("\\.bld$" . makefile-mode)
                ("\\.m$" . matlab-mode)
                ("\\.pl$" . perl-mode)
                ("\\.\(py\|ipy\)$" . python-mode)
                ("\\.\(bin\|exe\)$" . hexl-mode)
                ("\\.gdb$" . gdb-script-mode)
                ("\\.pro$" . qmake-mode)
                ) auto-mode-alist))

;;(setq-default show-trailing-whitespace t)
(tool-bar-mode 0)
(set-cursor-color "grey")
(setq x-stretch-cursor t)
(setq inhibit-startup-message t)
;; alias y to yes and n to no
(defalias 'yes-or-no-p 'y-or-n-p)
;; replace highlighted text when you start typing
(delete-selection-mode t)
;; highlight during searching
(setq query-replace-highlight t)
;; highlight incremental search
(setq search-highlight t)

;; Iswitchb is much nicer for inter-buffer navigation.
;; TODO: Switch to Icomplete. Iswitchdb is deprecated starting in Emacs 24.
(cond ((fboundp 'iswitchb-mode)                ; GNU Emacs 21
       (iswitchb-mode 1))
      ((fboundp 'iswitchb-default-keybindings) ; Old-style activation
       (iswitchb-default-keybindings))
      (t nil))                                 ; Oh well.

;; make RET run the indention command, if any.
(define-key global-map "\r" 'newline-and-indent)
(define-key global-map "\n" 'newline)

;; Kill Buffer
(defun kill-current-buffer ()
  (interactive)
  (kill-buffer nil))

;; Custom keybindings
(global-set-key [f1]     'tags-search)
(global-set-key [f2]     'tags-query-replace)
(global-set-key [f3]     'isearch-forward)
(global-set-key [f4]     'query-replace)
(global-set-key [f7]     'kill-current-buffer)
(global-set-key [f8]     'compile)
(global-set-key [f9]     'next-error)
(global-set-key "\M-g"   'goto-line)
(global-set-key "\M-$"   'query-replace-regexp)
(global-set-key "\M-r"   'replace-string)
(global-set-key "\M-/"   'hippie-expand)

;; Set the expansion rules for hippie-expand (the more intelligent alternative
;; to the default dabbrev-expand)
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line))

;; Placed versioned backup files
(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.backups")))

;; Use UNIX line endings by default
(set-buffer-file-coding-system 'utf-8-unix)
;; No, really. _Always_ use UNIX style line endings.
(defun set-unix-style-line-endings ()
  (set-buffer-file-coding-system 'unix))
(add-hook 'before-save-hook 'set-unix-style-line-endings)

;; Tell Emacs the C coding style to use
(defun my-c-mode-common-hook ()
  (c-set-style "k&r")
  (setq c-basic-offset 4)
  (setq c-block-comment-prefix "*"))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq load-path (append load-path '("~/.dotfiles/conf/emacs.d/")))

;; etags mode for C/C++ programmers
(require 'etags)

;; ClearCase interface
(if (file-readable-p "C:\\Program Files\\Rational\\ClearCase\\bin\\cleartool.exe")
    (load "clearcase"))

;; python-mode
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; bat-mode
(setq auto-mode-alist (cons '("\\.bat$" . bat-mode) auto-mode-alist))
(autoload 'bat-mode "bat-mode" "DOS Batch file editing mode." t)

;; tcl-mode
(defvar tcl-compile-command "make")
(defun tcl-compile () (interactive)
  (save-buffer)
  (shell-command (format tcl-compile-command buffer-file-name))
  )
(add-hook 'tcl-mode-hook
          '(lambda nil
             (define-key tcl-mode-map "\C-c\C-t" 'tcl-compile)))
;; TODO: set for tcl-mode only


;; Interactively Do
;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching t) ;; enable fuzzy matching

(load "code-templates")

(require 'matlab)

(load "qmake")

;; Cedet (see http://alexott.net/en/writings/emacs-devenv/EmacsCedet.html)
;; (require 'cedet)

;; ;; Enable the Project management system
;; (global-ede-mode 1)                      
;; ;; Enable prototype help and smart completion
;; (semantic-load-enable-code-helpers)      
;; ;; Enable template insertion menu
;; (global-srecode-minor-mode 1)            


;; Enable support for GNU Global
;; (require 'semanticdb-global)
;; (semanticdb-enable-gnu-global-databases 'c-mode)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)

;; (require 'php-mode)

(load "google-c-style")
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c++-mode-common-hook 'google-set-c-style)

(require 'linum+)

(require 'tramp)
(setq tramp-default-method "scp")

;;
;; web-mode.el
;;
;; See: http://web-mode.org/ for common customizations and shortcuts
;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; HTML offset indentation
(setq web-mode-markup-indent-offset 2)
;; CSS offset indentation
(setq web-mode-css-indent-offset 2)
;; Script offset indentation (for JavaScript, Java, PHP, etc.)
(setq web-mode-code-indent-offset 2)
