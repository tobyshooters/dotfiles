;; Set up package.el to work with MELPA
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package org
 :ensure t)

(use-package evil
 :ensure t
 :config
 (evil-mode 1))

;; Hide Scroll bar,menu bar, tool bar
(setq inhibit-startup-message t)
(menu-bar-mode -1)

;; Line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'absolute)

;; Auto-pair delimiters
(electric-pair-mode 1)

;; Vim key-bindings
(evil-define-key 'normal 'global
  (kbd ",f") 'find-file)

;; Mouse-scroll
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)
(xterm-mouse-mode t)

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
