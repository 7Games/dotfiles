;;; .emacs --- personal config of svngms -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(setq-default warning-minimum-level :emergency
              package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
                                 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(use-package rustic
  :ensure t
  :defer t
  :custom
  (rustic-format-on-save nil)
  (rustic-cargo-use-last-stored-arguments t)
  (rustic-rust-client 'eglot))

(use-package lua-mode
  :ensure t
  :defer t
  :custom
  (lua-indent-level 4))

(use-package gdscript-mode
  :ensure t
  :defer t)

(use-package eglot
  :defer t
  :hook (prog-mode . eglot-ensure))

(use-package flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode)
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error)))

(use-package company
  :ensure t
  :defer t
  :hook ((prog-mode eshell-mode ielm-mode) . company-mode))

(use-package multiple-cursors
  :ensure t
  :defer t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c h" . mc/mark-all-like-this))

(use-package magit
  :ensure t
  :defer t)

;; Uses `libenchant2'
(use-package jinx
  :ensure t
  :defer t
  :bind
  ("M-$" . jinx-correct)
  ("C-;" . jinx-correct)
  :hook
  (org-mode . jinx-mode))

;; Syntax highlighting for exported code blocks
(use-package ox-latex
  :defer t
  :after org
  :custom
  (org-latex-listings 'minted)
  (org-latex-packages-alist '(("" "minted")))
  (org-latex-pdf-process
   '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

(use-package org
  :ensure nil
  :custom
  (org-support-shift-select t))

(use-package editorconfig
  :init
  (editorconfig-mode 1))

(use-package prog-mode
  :hook
  (prog-mode . display-line-numbers-mode)
  (prog-mode . electric-pair-mode)
  :custom
  (tab-width 4)
  (c-basic-offset tab-width)
  (indent-tabs-mode nil)
  :bind
  ("C-c c" . compile)
  ("C-c r" . recompile))

(use-package dired
  :hook
  (dired-mode-hook . dired-omit-mode)
  :bind
  (:map dired-mode-map
        ("." . dired-omit-mode))
  :init
  (put 'dired-find-alternate-file 'disabled nil)
  :custom
  (dired-omit-files "^\\.[a-zA-Z0-9]+"))

(use-package completion
  :init
  (fido-vertical-mode 1)
  :bind
  (:map icomplete-fido-mode-map
        ("TAB" . icomplete-force-complete))
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(which-key-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)

(setq inhibit-splash-screen t
      inhibit-startup-screen t
      initial-scratch-message (format ";; GNU Emacs %i.%i\n\n"
                                      emacs-major-version
                                      emacs-minor-version)
      use-short-answers t
      ring-bell-function 'ignore
      backup-directory-alist '(("." . "~/.emacs.d/backups")))

(windmove-default-keybindings 'meta)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(add-hook 'before-save-hook 'whitespace-cleanup)

(load-theme 'wombat t)

;;; .emacs ends here
