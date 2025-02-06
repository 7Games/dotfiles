;; Personal config of svngms -*- lexical-binding: t -*-

(setq warning-minimum-level :emergency)

;; (setq use-package-compute-statistics t)

(push '("\\*compilation\\*" . (nil (reusable-frames . t))) display-buffer-alist)

(use-package customfile
  :ensure nil
  :defer t
  :init
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (load-file custom-file))

;; Hide startup screen when Emacs opens with a file
(defun my-inhibit-startup-screen-file ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option which
names an existing file."
  (ignore
   (setq inhibit-startup-screen
         (file-exists-p
          (expand-file-name argi command-line-default-directory)))))

(add-hook 'command-line-functions #'my-inhibit-startup-screen-file)

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

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package yasnippet
  :ensure t
  :hook ((prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  :init
  (setq yas-snippet-dir "~/.emacs.d/snippets"))

(use-package org
  :ensure nil
  :defer t
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :bind (("C-c a" . org-agenda)
         ("C-c c" . compile)
         ("C-c r" . recompile))
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
  (define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)
  (set-fringe-mode -1)
  (which-key-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (load-file "~/.emacs.d/site-lisp/splash-screen.el")
  (pixel-scroll-precision-mode 1))

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

(use-package eglot
  :ensure nil
  :defer t
  :hook (((c-mode c++-mode rust-mode) . eglot-ensure)))

;; End of .emacs
