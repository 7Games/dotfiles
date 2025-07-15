;;; .emacs --- personal config of svngms  -*- lexical-binding: t -*-
;;; Commentary:
;;; This is my personal Emacs config.  It used to be complex but over
;;; the years I have stripped it down and restarted over and over
;;; again.  Now I think it's a deceint config that has the bare
;;; minimum while still being good to use.
;;; Code:

;; Get rid of the custom changes
(setq custom-file "/dev/null")

;; Remove backups
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq backup-inhibited nil)

;; Remove some annoying stuff
(setq-default warning-minimum-level :emergency)
(setq use-short-answers t)
(setq ring-bell-function 'ignore)

;; Move between windows with meta (alt)
(windmove-default-keybindings 'meta)

;; Built-in file manager
(setq-default dired-omit-files "^\\.[a-zA-Z0-9]+")
(add-hook 'dired-mode-hook 'dired-omit-mode)
(add-hook 'dired-mode-hook
      (lambda ()
    (local-set-key (kbd ".") 'dired-omit-mode)))
(put 'dired-find-alternate-file 'disabled nil)

;; Stuff for `prog-mode'
(defun my/prog-mode ()
  "Custom `prog-mode'."
  (display-line-numbers-mode 1)
  (electric-pair-mode 1)
  (setq-default compilation-scroll-output t)
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  (setq-default tab-width 4)
  (setq-default c-basic-offset tab-width)
  (setq-default indent-tabs-mode nil))

(add-hook 'prog-mode-hook 'my/prog-mode)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c r") 'recompile)

;; EXTERNAL PACKAGES

;; Add melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
     ("C-<" . mc/mark-previous-like-this)
     ("C-c h" . mc/mark-all-like-this)))

;; Per-project editor configuration
(use-package editorconfig
  :ensure t
  :defer t
  :hook (prog-mode . editorconfig-mode))

;; Git client
(use-package magit
  :ensure t
  :defer t)

;; Spell checker
(use-package jinx
  :ensure t
  :bind (("M-$" . jinx-correct)
     ("C-;" . jinx-correct))
  :hook (org-mode . jinx-mode))

;; Better modeline
(use-package doom-modeline
  :ensure t
  :config (doom-modeline-mode 1))

;; YAML
(use-package yaml-mode
  :ensure t
  :defer t
  :mode ("\\.yml$|\\.yaml$" . yaml-mode))

;; Rust
(use-package rustic
  :ensure t
  :defer t
  :mode ("\\.rs$" . rustic-mode)
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer"))
  (rustic-lsp-client 'eglot))

;; Flycheck, shows errors in the file
(use-package flycheck
  :ensure t
  :defer t
  :hook (prog-mode . flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error)))

;; Style stuff here so if the config get's messed up I get flashbanged

;; Use better built-in completion system
(fido-vertical-mode 1)
(define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)

;; I use speed bar for project navigation
(global-set-key (kbd "C-c f") 'speedbar)

;; Remove ugly ui
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode -1)

;; Stop showing me this stuff!
(setq inhibit-splash-screen t)
(setq inhibit-startup-screen t)

;; Window style
(setq-default frame-title-format "GNU Emacs – %b")
(setq-default cursor-type 'bar)
(setq-default frame-resize-pixelwise t)

;; Random stuff I can't categorise
(which-key-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(context-menu-mode t)

;; Change font
(add-to-list 'default-frame-alist `(font . "Iosevka-13"))

;; Some better scrolling
(setq scroll-conservatively 10000)
(pixel-scroll-precision-mode 1)

;; Clean-up the whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Change theme
(load-theme 'wombat t nil)

;; And finally add the LSP
(add-hook 'prog-mode-hook 'eglot-ensure)

(provide '.emacs)
;;; .emacs ends here
