;; Personal config of svngms -*- lexical-binding: t -*-

;; Set the custom-file
(setq custom-file "~/.emacs.d/custom.el")

;; Setup backups
(setq make-backup-files nil
      create-lockfiles nil
      backup-inhibited nil)

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
  (setq compilation-scroll-output t)
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
  (setq-default tab-width 4
                c-basic-offset tab-width
                indent-tabs-mode nil))

(use-package prog-mode
  :ensure nil
  :defer t
  :bind (("C-c c" . compile)
         ("C-c r" . recompile))
  :hook (prog-mode . my/prog-mode))

;; Add cmake-mode
(use-package cmake-mode
  :ensure t
  :defer t)

;; lsp
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
  (setq eglot-ignored-server-capabilities '( :documentHighlightProvider))
  :hook (prog-mode . eglot-ensure))

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

;; Minibuffer completion
(use-package marginalia
  :ensure t
  :custom
  (marginalia-align 'right)
  :init
  (marginalia-mode 1))

(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-completion
  :ensure t
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package vertico
  :ensure t
  :custom
  (vertico-count 13)
  (vertico-resize t)
  (vertico-cycle nil)
  :config
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face 'vertico-current)
                   "  ")
                 cand)))
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;;
(use-package treemacs
  :ensure t
  :bind ("C-c f" . treemacs)
  :config
  (treemacs-git-mode 'extended)
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
  (with-eval-after-load 'doom-themes-ext-treemacs
    (remove-hook 'treemacs-mode-hook #'doom-themes-hide-modeline))
  (treemacs-indent-guide-mode 1)
  (treemacs-git-commit-diff-mode 1))

(use-package treemacs-magit
  :ensure t
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-icons-dired
  :ensure t
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

;; Auto complete
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)
  (corfu-preview-current 'insert)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)))

(use-package corfu-popupinfo
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.15 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background nil)
  (kind-icon-blend-frac 0.08)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

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

;; New modeline
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1))

;; Themes
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-material-dark t))

;; cool
(use-package rainbow-delimiters
  :ensure t)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Some random stuff to make emacs look and feel better
(which-key-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(setq-default frame-title-format "GNU Emacs – %b")
(pixel-scroll-precision-mode 1)
(setq-default context-menu-mode t)
(setq-default enable-recursive-minibuffers t)
(setq-default read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
(setq inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      frame-resize-pixelwise t)
(setq-default redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)
(setq-default cursor-type 'bar)
(set-cursor-color "#ffffff")

;; Change font
(add-to-list 'default-frame-alist `(font . "Iosevka-13"))

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
