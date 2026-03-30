;;; --- Package Management ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; Silence the native-comp warnings you were getting
(setq native-comp-async-report-warnings-errors 'silent)

;;; --- Visuals & Theme ---
(use-package moe-theme :config (load-theme 'moe-dark t))
(use-package powerline :config (powerline-center-theme)) ; Restored center-theme
(use-package yascroll :config (global-yascroll-bar-mode 1))
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

;;; --- Navigation & Editing (Restored your specific keys) ---
(use-package goto-last-change
  :bind ("C-x C-\\" . goto-last-change)) ; Restored your specific C-\ key

(use-package undo-tree
  :config (global-undo-tree-mode))

(use-package ace-jump-mode
  :bind ("C-o" . ace-jump-mode)
  :config (ace-jump-mode-enable-mark-sync))

(use-package expand-region
  :bind (("M-i" . er/expand-region)
         ("M-S-<up>" . er/mark-inside-quotes)
         ("M-S-<down>" . er/mark-inside-pairs)))

;;; --- Completion (Helm & Auto-Complete) ---
(use-package helm
  :config
  (helm-mode 1)
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files)
         ("C-x C-b" . helm-buffers-list)
         ("C-x C-r" . helm-recentf)
         ("C-c <SPC>" . helm-all-mark-rings)))

(use-package auto-complete
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t)
  (setq ac-dwim t))

;;; --- Git ---
(use-package git-gutter
  :config
  (global-git-gutter-mode t)
  :bind (("C-c n" . git-gutter:next-hunk)
         ("C-c l" . git-gutter:previous-hunk)))

;;; --- Your Restored Custom Functions ---

;; Line Movement
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion (forward-line) (transpose-lines 1))
    (forward-line) (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion (forward-line) (transpose-lines -1))
    (move-to-column col)))

(global-set-key (kbd "<C-M-down>") 'move-line-down)
(global-set-key (kbd "<C-M-up>") 'move-line-up)

;; Fast Vertical Navigation
(global-set-key (kbd "M-U") (lambda () (interactive) (forward-line -10)))
(global-set-key (kbd "M-D") (lambda () (interactive) (forward-line 10)))

;; "Mimic Vim" Open Line
(defun open-line-below ()
  (interactive) (end-of-line) (newline) (indent-for-tab-command))
(defun open-line-above ()
  (interactive) (beginning-of-line) (newline) (forward-line -1) (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)

;; Dired Improvements
(defun dired-back-to-top () (interactive) (beginning-of-buffer) (dired-next-line 4))
(with-eval-after-load 'dired
  (define-key dired-mode-map (vector 'remap 'beginning-of-buffer) 'dired-back-to-top))

;; Elisp Save Hack
(defun ome-remove-elc-on-save ()
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))))
(add-hook 'emacs-lisp-mode-hook 'ome-remove-elc-on-save)

;;; --- General Settings ---
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(delete-selection-mode 1)
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)
(global-set-key (kbd "M-j") (lambda () (interactive) (join-line -1)))

;; Terminal Transparency (for CachyOS terminal)
(defun my/fix-terminal-transparency (&optional frame)
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(my/fix-terminal-transparency)

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
