;; Set up package.el to work with MELPA
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Org-mode
(use-package org
 :ensure t)

;; Vim key-bindings
(use-package evil
 :ensure t
 :config
 (evil-mode 1))

(setq evil-normal-state-tag "NORMAL")
(setq evil-insert-state-tag "INSERT")
(setq evil-visual-state-tag "VISUAL")

(evil-define-key 'normal 'global
  (kbd ",f") 'find-file)

;; Creating splits
(define-key evil-normal-state-map
  (kbd ",v") 'split-window-horizontally)
(define-key evil-normal-state-map
  (kbd ",m") 'split-window-vertically)
(define-key evil-normal-state-map
  (kbd ",d") 'delete-window)

;; Moving between splits
(define-key evil-normal-state-map
  (kbd "C-h") 'windmove-left)
(define-key evil-normal-state-map
  (kbd "C-j") 'windmove-down)
(define-key evil-normal-state-map
  (kbd "C-k") 'windmove-up)
(define-key evil-normal-state-map
  (kbd "C-l") 'windmove-right)

<<<<<<< HEAD
;; Commenting
(define-key evil-visual-state-map
  (kbd ",cc") 'comment-region)
(define-key evil-visual-state-map
  (kbd ",cd") 'uncomment-region)

;; Writing
(use-package org :ensure t)
(use-package olivetti :ensure t)
(define-key evil-normal-state-map
  (kbd ",g") 'olivetti-mode)

;; Mouse scrolling
(xterm-mouse-mode 1)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;; Tool-bars and Menu-bars
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(setq-default mode-line-format (list "%f %* L%l"))

;; Line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'absolute)

;; Text-editing
(electric-pair-mode 1)
(setq-default fill-column 79)
(add-hook 'text-mode-hook '(lambda ()
                             (auto-fill-mode 1)))

=======
>>>>>>> 920bcf2a29639020319a13cbc82870ee1b6cd299
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
<<<<<<< HEAD
 '(package-selected-packages '(olivetti use-package evil)))
=======
 '(package-selected-packages (quote (evil use-package))))
>>>>>>> 920bcf2a29639020319a13cbc82870ee1b6cd299
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
