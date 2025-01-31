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
  :hook (after-init . (lambda () (windmove-default-keybindings 'meta)))
  :custom
  (undelete-frame-mode t)
  (use-short-answers t)
  (ring-bell-function 'ignore))

(use-package org
  :ensure nil
  :defer t
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))
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

(use-package startup
  :ensure nil
  :defer t
  :custom
  (inhibit-startup-screen t)
  (initial-major-mode 'fundamental-mode)
  (initial-scratch-message ""))

(defun my/prog-mode ()
  (hl-line-mode 1)
  (display-line-numbers-mode 1)
  (electric-pair-mode 1)
  (setq-default tab-width 4
                c-basic-offset tab-width
                indent-tabs-mode nil))

(defun my/ui ()
  (fido-vertical-mode 1)
  (define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)
  (set-fringe-mode -1)
  (which-key-mode 1)
  (pixel-scroll-precision-mode 1))

(use-package before-save
  :ensure nil
  :defer t
  :hook
  (before-save . whitespace-cleanup))

(use-package ui
  :ensure nil
  :defer t
  :hook (after-init . my/ui))

(use-package prog-mode
  :ensure nil
  :defer t
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

(use-package plantuml-mode
  :ensure t
  :defer t
  :custom ((plantuml-jar-path "~/.local/bin/plantuml.jar")
           (org-plantuml-jar-path "~/.local/bin/plantuml.jar")
           (plantuml-default-exec-mode 'jar)))

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

;; End of .emacs
