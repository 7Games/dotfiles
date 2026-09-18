;;; .emacs --- personal config of svngms -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(package-initialize)
(setq-default warning-minimum-level :emergency
              package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
                                 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                                 ("melpa" . "https://melpa.org/packages/")
                                 ("melpa-stable" . "https://stable.melpa.org/packages/")))

;; remember to run (package-refresh-contents) every so often

(use-package multiple-cursors
  :ensure t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c h" . mc/mark-all-like-this))

(use-package rustic
  :ensure t
  :defer t
  :custom
  (rustic-format-on-save nil)
  (rustic-cargo-use-last-stored-arguments t)
  (rustic-rust-client 'eglot))

(use-package cmake-mode
  :ensure t
  :defer t)

(setq large-file-warning-threshold 999999999999999)

(use-package company-mode
  :ensure nil
  :defer t
  :config
  (company-global-mode 1))

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

(use-package lua-mode
  :ensure t
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode)))

(use-package lsp-mode
  :ensure t
  :hook (lua-mode . lsp-deferred)
  :config
  (setq lsp-clients-lua-language-server-bin "/home/benjamin/.local/lua-language-server-3.19.1-linux-x64/bin/lua-language-server")
  (plist-put lsp-lua-workspace-library ["${3rd}/love2d/library"]))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(lua-mode . ("/home/benjamin/.local/lua-language-server-3.19.1-linux-x64/bin/lua-language-server")))
  (add-to-list 'eglot-server-programs
               '(lua-ts-mode . ("/home/benjamin/.local/lua-language-server-3.19.1-linux-x64/bin/lua-language-server"))))

(use-package magit
  :ensure t)

;; Uses `libenchant2'
(use-package jinx
  :ensure t
  :defer t
  :bind
  ("M-$" . jinx-correct)
  ("C-;" . jinx-correct)
  :hook
  (org-mode . jinx-mode))

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

(use-package editorconfig
  :init
  (editorconfig-mode 1))

(use-package manga
  :load-path "~/.emacs.d/external/manga-reader/"
  :commands (manga manga-open-local manga-library)
  :custom
  (manga-library-dir    "~/Archive/Literature/Manga/")
  (manga-download-dir   "~/Archive/Literature/Manga/00 unsorted/")
  (manga-image-fit      'width)
  (manga-preload-pages  3))

(use-package rainbow-delimiters
  :ensure t
  :defer t)

(use-package prog-mode
  :hook
  ;; (prog-mode . company-mode)
  (prog-mode . display-line-numbers-mode)
  (prog-mode . electric-pair-mode)
  ;; (prog-mode . rainbow-delimiters-mode)
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
  (dired-guess-shell-alist-user
   (append '(;;("\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" "feh --start-at")
             ("\\.\\(mp4\\|mkv\\|avi\\|mov\\|wmv\\|flv\\|mpg\\)$" "mpv"))
           dired-guess-shell-alist-user))
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

(which-key-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode '(0 . 0))

(setq inhibit-startup-screen t)

(setq initial-scratch-message (format ";; GNU Emacs v%i.%i\n\n" emacs-major-version emacs-minor-version))

(defun mode-line-left-padding ()
  "Add padding to the left of mode line if olivetti mode is enabled."
  (propertize " "
              'display `(space :align-to (- left 1))))

(defun mode-line-right-padding (format)
  "Move elements to the right of the mode line."
  (let ((format-length (length (format-mode-line format))))
    (propertize " "
                'display `(space :align-to (- right ,format-length)))))

(defun mode-line-save-indicator ()
  (cond
   (buffer-read-only (propertize "%-" 'face '(:foreground "darkgray")))
   ((buffer-modified-p) (propertize "*" 'face '(:foreground "goldenrod")))))

(setq-default mode-line-format '((:eval (mode-line-left-padding))
                                 " %F - %b "
                                 (:eval (mode-line-save-indicator))
                                 " %e "
                                 (:eval (mode-line-right-padding "%l:%c (%p) [%m] "))
                                 "%l:%c (%p)  [%m]"))

(setq mode-line-format nil)

(setq scroll-conservatively 1000)
(pixel-scroll-precision-mode 1)

(if (display-graphic-p)
    (progn
      (set-frame-font "Iosevka Comfy 13")
      (load-theme 'wombat t)
      (set-background-color "#1e1e1e")
      (set-default 'cursor-type '(bar . 1))
      (set-cursor-color "goldenrod")
      (blink-cursor-mode 1)
      (setq frame-title-format '("" "GNU Emacs - %b"))
      (setq-default left-margin-width 1 right-margin-width 1)
      (set-frame-parameter (selected-frame) 'internal-border-width 13)
      (add-to-list 'default-frame-alist '(undecorated . t))
      (add-to-list 'default-frame-alist '(alpha-background . 90)))
  (progn
    (global-set-key (kbd "C-h") 'backward-kill-word)))

(dolist (var '(default-frame-alist initial-frame-alist))
  (add-to-list var '(internal-border-width . 20)))

(setq use-short-answers t
      ring-bell-function 'ignore
      backup-directory-alist '(("." . "~/.emacs.d/backups")))

(windmove-default-keybindings 'meta)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(add-hook 'before-save-hook 'whitespace-cleanup)

(setq compilation-scroll-output t)

;;; .emacs ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cmake-mode company corfu elcord forth-mode jinx lsp-mode lua-mode
                luarocks magit multiple-cursors rainbow-delimiters
                rustic slime yaml))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
