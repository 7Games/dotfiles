;;; .emacs --- personal config of svngms -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; no warnings
(setq-default warning-minimum-level :emergency)

;; utf-8
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

;; use-package
(require 'package)
(package-initialize)

(setq package-archives '(("gnu"          . "http://elpa.gnu.org/packages/")
			 ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
			 ("melpa"        . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :defer t
  :bind ("C->" . mc/mark-next-like-this)
	("C-<" . mc/mark-previous-like-this)
	("C-c h" . mc/mark-all-like-this))

;; cmake
(use-package cmake-mode
  :ensure t
  :defer t)

;; company
(use-package company-mode
  :defer t
  :hook (prog-mode . company-mode))

;; lua
(use-package lua-mode
  :ensure t
  :defer t
  :mode ("\\.lua\\'" . lua-mode))

;; magit
(use-package magit
  :ensure t
  :defer t)

;; editor-config
(use-package editorconfig
  :ensure t
  :hook (prog-mode . editorconfig-mode))


;; Eglot (only thing to actually make use of use-package's features)
(use-package eglot
  :ensure nil
  :defer t
  :custom
  (lsp-idle-delay 0.1)
  (fset #'jsonrpc--log-event #'ignore)
  (setf (plist-get eglot-events-buffer-config :size) 0)
  (eglot-events-buffer-size 0)
  (eglot-sync-connect nil)
  (eglot-connect-timeout nil)
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 3)
  (flymake-no-changes-timeout 5)
  (eldoc-echo-area-use-multiline-p nil)
  (eglot-ignored-server-capabilities '( :documentHighlightProvider))
  :hook (prog-mode . eglot-ensure))

;; misc
(setq ring-bell-function 'ignore
      use-short-answers t
      create-lockfiles nil
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

(delete-selection-mode 1)
(which-key-mode 1)
(global-eldoc-mode 1)

(windmove-default-keybindings 'meta)

(add-hook 'before-save-hook 'whitespace-cleanup)

;; fido
(fido-vertical-mode 1)

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

(define-key icomplete-fido-mode-map (kbd "<tab>") 'icomplete-force-complete)
(define-key icomplete-fido-mode-map (kbd "M-j")   'icomplete-ret)

;; compilation
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(setq compilation-scroll-output t)
(setq-default compilation-scroll-output t)

;; prog-mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

(setq tab-width 4
      c-basic-offset tab-width
      indent-tabs-mode nil)

(bind-key "C-c c" 'compile)
(bind-key "C-c r" 'recompile)

;; style
(set-frame-font "Iosevka Comfy 13")
(load-theme 'wombat t)
(set-face-attribute 'fringe nil :background "#242424" :foreground "red")

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(column-number-mode 1)

(setq scroll-step 1
      scroll-conservatively 101
      inhibit-startup-screen t)

;; custom function
(defun svn//duplicate-line ()
  (interactive)
  (let ((col (current-column)))
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (open-line 1)
    (next-line 1)
    (yank)
    (move-to-column col)))

(defun svn//transparent-background (&optional alpha)
  (interactive)
  (let ((num (or alpha 95)))
    (set-frame-parameter nil 'alpha-background num)))

;; keybinds
(bind-key "C-c C-d" 'svn//duplicate-line)
(bind-key "C-c t" 'svn//transparent-background)
(bind-key "M-z" 'zap-up-to-char)

;; custom stuff emacs keeps putting here
(put 'dired-find-alternate-file 'disabled nil)
