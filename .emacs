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

;; jinx (uses `libenchant2')
(use-package jinx
  :ensure t
  :defer t
  :bind
  ("M-$" . jinx-correct)
  ("C-;" . jinx-correct)
  :hook
  (org-mode . jinx-mode))

;; hl-todo
(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(("TODO" warning bold)
          ("FIXME" error bold)
          ("HACK" font-lock-constant-face bold)
          ("REVIEW" font-lock-keyword-face bold)
          ("DESC" custom-variable-obsolete bold)
          ("URL" custom-variable-obsolete bold)
          ("NOTE" success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

;; eglot
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

(with-eval-after-load 'eglot
  (add-to-list 'eglot-ignored-server-capabilities :documentRangeFormattingProvider))

;; eshell
(setq eshell-prompt-function
      (lambda ()
        (concat
         (propertize (if (= (user-uid) 0) "[#]" "[$]") 'face `(:foreground "white"))
         (propertize (concat (replace-regexp-in-string (getenv "HOME") "~" (eshell/pwd)) " ") 'face `(:foreground "white")))))
;; based off https://github.com/howardabrams/dot-files/blob/master/emacs-eshell.org#aliases
(add-hook 'eshell-mode-hook (lambda ()
                              (eshell/alias "e" "find-file $1")
                              (eshell/alias "ee" "find-file-other-window $1")
                              (eshell/alias "emacs" "find-file $1")
                              (eshell/alias "d" "dired $1")))

;; imood.el
(load-file "~/.emacs.d/site-lisp/imood.el")
(load-file "~/.emacs.d/secrets.el")

;; misc
(setq ring-bell-function 'ignore
      use-short-answers t
      create-lockfiles nil
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

(setq-default indent-tabs-mode nil)

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
(add-hook 'prog-mode-hook (lambda ()
                            (setq tab-width 4
                                  c-basic-offset tab-width
                                  indent-tabs-mode nil)))

(setq tab-width 4
      c-basic-offset tab-width
      indent-tabs-mode nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(bind-key "C-c c" 'compile)
(bind-key "C-c r" 'recompile)

;; imood
(load "~/.emacs.d/site-lisp/imood.el")
(load "~/.emacs.d/secrets.el")

;; style
;; (add-to-list 'default-frame-alist '(font . "PxPlus IBM VGA8 16"))
(add-to-list 'default-frame-alist '(font . "Iosevka Comfy 13"))
(load-theme 'wombat t)
(set-background-color "#222")

(fringe-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(window-divider-mode -1)
(column-number-mode 1)

(setq-default frame-title-format "GNU Emacs – %b"
              cursor-type 'bar)

(setq scroll-step 1
      scroll-conservatively 101
      inhibit-startup-screen t
      initial-scratch-message (format ";; GNU Emacs v%i.%i\n\n" emacs-major-version emacs-minor-version))

(add-to-list 'default-frame-alist '(undecorated . t))
(dolist (var '(default-frame-alist initial-frame-alist))
  (add-to-list var '(right-divider-width . 20))
  (add-to-list var '(internal-border-width . 20)))

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

(svn//transparent-background 90)

;; keybinds
(bind-key "C-c C-d" 'svn//duplicate-line)
(bind-key "C-c t" 'ansi-term)
(bind-key "C-c s" 'eshell)
(bind-key "M-z" 'zap-up-to-char)

;; custom stuff emacs keeps putting here
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ada-mode all-the-icons-dired cmake-mode company elsqlite forth-mode
              hl-todo jinx lsp-mode lua-mode magit minimal-dashboard
              multiple-cursors rainbow-delimiters vertico yaml)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
