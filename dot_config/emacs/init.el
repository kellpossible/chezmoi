;; === Install/Setup Packages ===
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-list '(transpose-frame bind-key undo-tree hl-todo rainbow-mode magit-todos
evil-collection evil-commentary evil-smartparens smartparens
po-mode vterm-toggle vterm ace-window treemacs-icons-dired
treemacs-magit treemacs-evil lsp-treemacs treemacs helm-ls-git
helm-lsp helm which-key company edit-indirect deadgrep magit writeroom-mode monokai-theme markdown-mode simpleclip
telephone-line restart-emacs evil-multiedit evil lsp-ui yasnippet
flycheck rustic lsp-mode f))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; tell emacs where personal elisp lib dir is
(add-to-list 'load-path "~/.config/emacs/lisp/")

;; === Smartparens Settings ===
;; (require 'smartparens-config)

;; Handle situation where pressing enter when cursor is betwen braces: 
;; 1. {|}
;; 2. {
;;     |	
;; }
(sp-local-pair 'rustic-mode "{" nil :post-handlers '(:add ("||\n[i]" "RET")))
(sp-local-pair 'rustic-mode "[" nil :post-handlers '(:add ("||\n[i]" "RET")))

;; === Treemacs Settings ===
(require 'treemacs)
(define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))

;; === Evil-Mode Settings ===
;; Prescribed because of https://github.com/emacs-evil/evil-collection/issues/60 
(setq evil-want-C-u-scroll t)
(setq evil-want-keybinding nil)
; enable always respecting the visual representation of a line for up and down
(setq evil-respect-visual-line-mode t)
(require 'evil)
(evil-mode 1)
(require 'evil-markdown)
(evil-collection-init)
(evil-commentary-mode)
(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

(require 'undo-tree)
(global-undo-tree-mode 1)

;; === Which-Key Settings ===
(require 'which-key)
(which-key-mode t)

;; === Smart Home Key ===
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))


;; === Telephone-Line Settings ===
(require 'telephone-line)
(telephone-line-mode t)

(setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-erc-modified-channels-segment
                     telephone-line-process-segment))
          (nil    . (telephone-line-minor-mode-segment
                     telephone-line-buffer-segment))))
(setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))

;; === Separedit Settings ===
(require 'separedit)
(define-key prog-mode-map (kbd "C-c '") #'separedit)
(setq separedit-default-mode 'markdown-mode) ;; or org-mode


;; === lsp-ui-doc Settings ===
; (lsp-ui-doc-mode -1)
; (defvar lsp-ui-doc-visible nil)
; (defun lsp-ui-doc-toggle ()
;   "Toggle the visibility of the lsp-ui-doc frame"
;   (interactive)
;   (setf lsp-ui-doc-visible (not lsp-ui-doc-visible))
;   (funcall (if lsp-ui-doc-visible #'lsp-ui-doc-hide #'lsp-ui-doc-show)))

;; === Rust Settings ===
(setq rustic-lsp-server 'rust-analyzer)
(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq rust-format-on-save t)

(add-hook 'rustic-mode-hook
          (lambda () (local-set-key (kbd "C-c l") #'lsp-rust-analyzer-inlay-hints-mode)))
(add-hook 'rustic-mode-hook
          (lambda () (local-set-key (kbd "C-c .") #'lsp-execute-code-action)))
(add-hook 'rustic-mode-hook
          (lambda () (local-set-key (kbd "C-c C-t") #'rustic-cargo-current-test)))
(add-hook 'rustic-mode-hook
          (lambda () (local-set-key (kbd "C-c r") #'rustic-popup)))

(add-hook 'rustic-mode-hook #'lsp-deferred)
(add-hook 'rustic-mode-hook #'company-mode)
(add-hook 'lsp-after-open-hook (lambda ()
                                 (when (lsp-find-workspace 'rust-analyzer nil)
                                   (lsp-rust-analyzer-inlay-hints-mode))))

(add-hook 'before-save-hook (lambda () (when (eq 'rustic-mode major-mode)
                                           (lsp-format-buffer))))

(add-hook 'rustic-mode-hook #'yas-minor-mode)
(evil-set-initial-state 'rustic-popup-mode 'emacs)
(add-hook 'rustic-mode-hook #'smartparens-mode)

;; === Simpleclip Settings ===
(require 'simpleclip)
(simpleclip-mode 1)

;; === Beancount Settings ===
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))

;; === Markdown-Mode Settings === 
; use "## Heading" instead of "## Heading ##"
(setq markdown-asymmetric-header t)

(add-hook 'markdown-mode-hook #'visual-line-mode)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "chocolate1" :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :foreground "#66d9ef" :height 1.15))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :foreground "#e6db74" :height 1.1))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :foreground "#a1efe4")))))

;; === Line Numbers ===
(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; === Hanging Braces Settings ====


;; === Vterm Settings ===
(require 'vterm)

(add-hook 'vterm-mode-hook
		(lambda ()
		(setq-local evil-insert-state-cursor 'box)
		(evil-insert-state)))

(setq vterm-keymap-exceptions nil)

;; === General Editor Settings ===
(load-theme 'monokai t)
(desktop-save-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(show-paren-mode 1)
(setq make-backup-files nil)
(setq-default fill-column 70)

;; === Helm Settings === 
(require 'helm-ls-git)

;; === Highlight Todos Settings ===
(global-hl-todo-mode)
(setq hl-todo-keyword-faces
      '(("TODO"   . "#FFFF00")
        ("FIXME"  . "#FF0000")
        ("DEBUG"  . "#A020F0")))

;; === Key Bindings ===
(require 'bind-key)
(bind-key "<f3>" #'deadgrep)
(bind-key "C-`" #'vterm-toggle)
(bind-key "C-<f2>" #'vterm-toggle-cd)
(bind-key "C-c ;" #'lsp-find-references)
(bind-key "C-c /" #'lsp-find-definition)
(bind-key "C-c t" #'helm-lsp-workspace-symbol)
(bind-key "C-c p" #'helm-browse-project)
(bind-key "C-c ." #'helm-lsp-code-actions)
(bind-key "C-c b" #'treemacs)
(bind-key "C-c e" #'lsp-treemacs-errors-list)
(bind-key "C-c s" #'lsp-treemacs-symbols)
(bind-key "C-c w" #'ace-window)
(bind-key "C-c v" #'toggle-truncate-lines)
(bind-key "C-c g" #'magit)
(bind-key "C-c C-g" #'magit-todos-list)
(bind-key "C-c u" #'find-file-at-point)
(bind-key "C-c d" #'lsp-ui-doc-toggle)
(bind-key "<C-mouse-4>" #'text-scale-increase)
(bind-key "<C-mouse-5>" #'text-scale-decrease)
(bind-key "<home>" #'smart-beginning-of-line)
(bind-key "<C-M-left>" #'evil-jump-backward)
(bind-key "<C-M-right>" #'evil-jump-forward)
(bind-key "C-c c" #'simpleclip-copy)
(bind-key "C-c y" #'simpleclip-paste)
(bind-key "C-M-b" #'helm-buffers-list)
; (bind-key "C-w M-t" #'transpose-frame)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-undo-system 'undo-tree)
 '(helm-minibuffer-history-key "M-p"))
