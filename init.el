(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;; --- Visuals & Theme ---
(use-package nerd-icons)

(use-package moe-theme
  :config
  (load-theme 'moe-dark t))

(use-package powerline
  :config
  (powerline-default-theme))

(use-package yascroll
  :config
  (global-yascroll-bar-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; --- Navigation & Editing ---
(use-package goto-last-change
  :bind ("C-x C-/" . goto-last-change))

(use-package helm
  :init
  (setq helm-mode-fuzzy-match t
        helm-completion-in-region-fuzzy-match t)
  :config
  (helm-mode 1)
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)))

(use-package elscreen
  :init
  ;; Prevent elscreen from trying to load w3m and wl helpers
  (setq elscreen-display-tab nil) 
  (setq elscreen-tab-display-control nil)
  :config
  (elscreen-start))
;;; --- File Management ---
(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omitted index)))
  (dirvish-attributes '(file-size vc-state git-msg nerd-icons))
  ;; Terminal-friendly settings
  (dirvish-use-header-line nil)
  (dirvish-use-mode-line t)
  :config
  (dirvish-peek-mode) ; Preview files in the right pane
  (setq dirvish-layout-config '((0 0.3 0.4 0.3))) ; 3-column Miller columns

  :bind
  (("C-x d" . dirvish)
 :map dirvish-mode-map
 ("a"   . dirvish-quick-access)
 ("f"   . dirvish-file-info-menu)
 ("y"   . dirvish-yank-menu)
 ("s"   . dirvish-quicksort)
 ("TAB" . dirvish-subtree-toggle)
 ("M-t" . dirvish-layout-toggle)
 ("M-b" . dirvish-history-jump)
 ("M-s" . dirvish-setup-menu)
 ("M-e" . dirvish-emerge-menu)))

;;; --- Language Specifics ---
(use-package paredit
  :hook ((emacs-lisp-mode lisp-mode scheme-mode) . enable-paredit-mode))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

;;; --- Custom Settings ---
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(delete-selection-mode 1)

(defun my/fix-terminal-transparency (&optional frame)
  "Remove background color to let terminal transparency show through."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)
    (set-face-background 'fringe "unspecified-bg" frame)))

;; Apply to the current session
(my/fix-terminal-transparency)

;; Apply to any new frames (like if you use emacsclient)
(add-hook 'after-make-frame-functions 'my/fix-terminal-transparency)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
