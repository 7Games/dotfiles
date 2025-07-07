;; Personal config of svngms -*- lexical-binding: t -*-

;; Set the custom-file
(setq custom-file "~/.emacs.d/custom.el")

;; Setup backups
(setq make-backup-files nil
      create-lockfiles nil
      backup-by-copying t)

;; Remove some annoyances
(setq warning-minimum-level :emergency)
(push '("\\*compilation\\*" . (nil (reusable-frames . t))) display-buffer-alist)
(add-hook 'after-init-hook (lambda () (windmove-default-keybindings 'meta)))
(setq use-short-answers t
      ring-bell-function 'ignore)

;; Add package repos
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(package-initialize)

;; Directory editor
(use-package dired
  :ensure nil
  :defer t
  :custom (dired-omit-files "^\\.[a-zA-Z0-9]+")
  :hook (dired-mode . dired-omit-mode)
  :bind (:map dired-mode-map ("." . dired-omit-mode))
  :init (put 'dired-find-alternate-file 'disabled nil))

;; Customize `prog-mode'
(defun my/prog-mode ()
  (display-line-numbers-mode 1)
  (electric-pair-mode 1)
  (setq-default tab-width 4
                c-basic-offset tab-width
                indent-tabs-mode nil))

(use-package prog-mode
  :ensure nil
  :defer t
  :bind (("C-c c" . compile)
         ("C-c r" . recompile))
  :hook (prog-mode . my/prog-mode))

;; lsp
(use-package lsp-ui
  :pin melpa
  :ensure t
  :defer t)

(use-package eglot
  :ensure nil
  :defer t
  :hook (((c-mode c++-mode rust-mode gdscript-mode python-mode) . eglot-ensure)))

;;
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Snippet system
(use-package yasnippet
  :ensure t
  :defer t
  :hook ((prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  :custom (yas-snippet-dir "~/.emacs.d/snippets"))

;; Org stuff
(use-package org
  :ensure nil
  :defer t
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :bind (("C-c a" . org-agenda))
  :custom (org-support-shift-select t))

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :defer t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c h" . mc/mark-all-like-this)))

;; Git client
(use-package magit
  :ensure t
  :defer t)

;; Spell checker
(use-package jinx
  :ensure t
  :defer t
  :bind (("M-$" . jinx-correct)
         ("C-;" . jinx-correct))
  :hook (org-mode . jinx-mode))

;; Auto complete
(use-package company
  :ensure t
  :defer t
  :hook ((prog-mode . company-mode)
         (shell-mode . company-mode)
         (eshell-mode . company-mode)))

;; Rust stuff
(use-package rust-mode
  :ensure t
  :defer t
  :config (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

;; Godot scripting language
(use-package gdscript-mode
  :ensure t
  :defer t
  :config (add-to-list 'auto-mode-alist '("\\.gd\\'" . gdscript-mode))
  :custom
  (gdscript-godot-executable "/usr/bin/godot")
  (gdscript-docs-local-path "/home/benjamin/Documents/ARCHIVE/godot-docs-html-stable"))

;; Show docstring and keybinds for M-x
(use-package marginalia
  :ensure t
  :config (marginalia-mode 1))

;; Some random stuff to make emacs look and feel better
(fido-vertical-mode 1)
(define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)
(which-key-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(setq frame-title-format "GNU Emacs – %b")
(pixel-scroll-precision-mode 1)

;; Change theme
(load-theme 'wombat t nil)

;; Hide the ugly stuff
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode -1)

;; Clean-up the whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Load the custom-file
(load custom-file)

(provide 'init)
;; init.el ends here
