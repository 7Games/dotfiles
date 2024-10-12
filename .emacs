;; Personal config of svngms -*- lexical-binding: t -*-

(setq warning-minimum-level :emergency)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load-file custom-file)

(setq backup-directory-alist '(("." . (expand-file-name "backups" user-emacs-directory)))
      backup-by-copying t)

(setq-default tab-width 4
              c-basic-offset tab-width
              indent-tabs-mode nil)

(setq use-short-answers t
      ring-bell-function 'ignore)

(setq org-support-shift-select t)

(use-package multiple-cursors
  :ensure t
  :defer t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c h" . mc/mark-all-like-this)))

(use-package magit
  :ensure t
  :defer t)

(setq inhibit-startup-screen t
      initial-scratch-message (format ";; GNU Emacs %i.%i\n\n" emacs-major-version emacs-minor-version))

(defun my/after-init ()
  "Things to run `after-init'."
  (windmove-default-keybindings 'meta)
  (set-fringe-mode -1)
  (electric-pair-mode 1)
  (fido-vertical-mode 1)
  (define-key icomplete-fido-mode-map (kbd "TAB") 'icomplete-force-complete)
  (load-theme 'wombat t))

(defun my/prog-mode ()
  "Things to run in `prog-mode'."
  (hl-line-mode 1)
  (display-line-numbers-mode 1))

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'after-init-hook  'my/after-init)
(add-hook 'prog-mode-hook   'my/prog-mode)

;; End of .emacs
