;; Personal config of svngms -*- lexical-binding: t -*-

(setq warning-minimum-level :emergency)

;; (setq use-package-compute-statistics t)

(use-package customfile
  :ensure nil
  :defer t
  :init
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (load-file custom-file))

(use-package backup
  :ensure nil
  :defer t
  :custom
  (make-backup-files nil)
  (create-lockfiles nil)
  (backup-by-copying t))

(use-package annoyances
  :ensure nil
  :defer t
  :config
  (push '("\\*compilation\\*" . (nil (reusable-frames . t))) display-buffer-alist)
  :hook (after-init . (lambda () (windmove-default-keybindings 'meta)))
  :custom
  (use-short-answers t)
  (ring-bell-function 'ignore))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package yasnippet
  :ensure t
  :defer t
  :hook ((prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  :config
  (setq yas-snippet-dir "~/.emacs.d/snippets"))

(use-package org
  :ensure nil
  :defer t
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :bind (("C-c a" . org-agenda))
  :config
  (setq org-agenda-files '("~/Documents/School/Tri2/attendance.org"))
  :custom
  (org-support-shift-select t))

(use-package dired
  :ensure nil
  :defer t
  :custom (dired-omit-files "^\\.[a-zA-Z0-9]+")
  :hook (dired-mode . dired-omit-mode)
  :bind (:map dired-mode-map ("." . dired-omit-mode))
  :init (put 'dired-find-alternate-file 'disabled nil))

(defun my/prog-mode ()
  (hl-line-mode 1)
  (display-line-numbers-mode 1)
  (electric-pair-mode 1)
  (setq-default tab-width 4
                c-basic-offset tab-width
                indent-tabs-mode nil))

(use-package before-save
  :ensure nil
  :defer t
  :hook
  (before-save . whitespace-cleanup))

(defun my/ui ()
  (add-to-list 'default-frame-alist '(height . 37))
  (add-to-list 'default-frame-alist '(width . 80))
  (fido-vertical-mode 1)
  (setq frame-title-format "GNU Emacs – %b")
  (define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)
  (set-fringe-mode -1)
  (which-key-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (pixel-scroll-precision-mode 1))

(use-package ui
  :ensure nil
  :defer t
  :hook (after-init . my/ui))

(use-package prog-mode
  :ensure nil
  :defer t
  :bind (("C-c c" . compile)
         ("C-c r" . recompile))
  :hook (prog-mode . my/prog-mode))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

(use-package multiple-cursors
  :ensure t
  :defer t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c h" . mc/mark-all-like-this)))

(use-package magit
  :ensure t
  :defer t)

(use-package jinx
  :ensure t
  :defer t
  :bind (("M-$" . jinx-correct)
         ("C-;" . jinx-correct))
  :hook (org-mode . jinx-mode))

(use-package pdf-tools
  :ensure t
  :defer t
  :init (pdf-loader-install))

(use-package exec-path-from-shell
  :ensure t
  :hook (python-mode . eglot-ensure)
  :init (exec-path-from-shell-initialize))

(use-package company
  :ensure t
  :hook ((prog-mode . company-mode)
         (shell-mode . company-mode)
         (eshell-mode . company-mode)))

(use-package rust-mode
  :ensure t
  :defer t
  :config (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(use-package eglot
  :ensure nil
  :defer t
  :hook (((c-mode c++-mode rust-mode) . eglot-ensure)))

(load-file "~/.emacs.d/site-lisp/emacs-splash/splash-screen.el")

;; End of .emacs
