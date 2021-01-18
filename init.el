;; My Basic emacs configuration.


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


;; Set Personal Information
(setq user-full-name "Abhilash Raj"
      user-mail-address "maxking@asynchronous.in")

;; Setup UTF-8.
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Variables configured via interactive `customize` command
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Setup package management repos.
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("elpy" .  "http://jorgenschaefer.github.io/packages/")))
(package-initialize)
(package-refresh-contents)

;; Setup use package.
(dolist (package '(use-package))
  (unless (package-installed-p package)
     (package-install package)))

;; Install paradox for managing packages.
(use-package paradox
  :ensure t
  :config
  (paradox-enable))


;; Setup themes.
(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))


;; Setup magit.
(use-package magit
  :ensure t
  :bind (("s-g" . magit-status))
  :config
  (use-package hl-todo
    :ensure t
    :config
    (hl-todo-mode))
  (setq
   magit-save-some-buffers nil
   magit-process-popop-time 10
   magit-diff-refine-hunk t))


;; Setup some customizations.
(setq-default
 ;; Inhibit startup stuff.
 inhibit-start-message t
 inhibit-splash-screen t
 initial-scratch-message nil
 font-lock-maximum-decoration t
 ;; Do not indent with tabs.
 indent-tabs-mode nil
 ;; Add a final newline.
 require-final-newline t
 ;; Resize the 
 resize-minubuffer-frame t
 column-number-mode t
 blink-matching-paren t
 blick-matching-delay 0.25
 ;; Initial major mode.
 initial-major-mode 'text-mode
 ;; The default tab width is set to 4 spaces.
 tab-width 4
 ;; Case-insensitive search.
 case-fold-search nil
 tooltip-delay 1.5
 ;; flash screen for a visible bell.
 visible-bell t
 ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Auto-Scrolling.html
 ;; How close the point can come to top or bottom of the window.
 scroll-margin 3
 ;; Fill column size is 79 chars.
 fill-column 79
 ;; Browser setup.
 browse-url-borwser-function 'browse-url-generic
 browse-url-generic-program "firefox"
 )

(setq
 ;; Set backup to a sinle path.
 backup-directory-alist '(("." . "~/.saves"))
 ;; Next line settings.
 next-line-extends-end-of-buffer nil
 next-line-add-newlines nil
  ;; show stack trace on any error.
 stack-trace-on-error t
 ;; Use the system clipboard.
 x-select-enable-clipboard 1
 ;; Always follow symlinks.
 vc-follow-symlinks t)
;; electric pair mode.
(electric-pair-mode 1)
;; line number.
(global-linum-mode 1)
;; Show paerns.
(show-paren-mode t)
;; Delete seletected text by typing *anything*.
(delete-selection-mode nil)

;; Setup some useful keybindings.
(global-set-key
 (kbd "C-<return>") 'other-window)
(define-key global-map [?\s-i] 'find-user-init-file)

;; Unset Ctrl-z when in descrete window.
(when window-system
  (global-unset-key [(control z)]))

;; Remove toolbar, menubar, scrollbar and tooltips
;;------------------------------------------------
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-scroll-bar-mode 'nil)

;; Display settings
(add-to-list 'default-frame-alist '(width  . 89))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(font . "Inconsolata-11"))


;; Setup mouse mode.
(use-package xt-mouse
  :config
  (xterm-mouse-mode))
(use-package mouse
  :config
  (xterm-mouse-mode t))

(defun track-mouse (e))

;; Recent files.
(recentf-mode 1)
(setq recentf-max-menu-items 100)

;; Global hilight mode.
(global-hl-line-mode 1)

;; y-or-n-p mode instead of yes or no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Show the line at 79 columns.
(use-package fill-column-indicator
  :ensure t
  :config
  (define-globalized-minor-mode
    global-fci-mode fci-mode (lambda () (fci-mode 1)))
  (global-fci-mode 1))


;; Highlight escape sequences.
(use-package highlight-escape-sequences
  :ensure t
  :config
  (hes-mode))

;; Setup projectile to handle git and stuff.
(use-package projectile
  :ensure t
  :config
  (setq
   projectile-sort-order 'default
   projectile-enable-caching t
   projectile-completion-system 'ivy)
  (add-hook 'prog-mode-hook 'projectile-mode))

;; Some useful functions.
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

;; Setup some useful keybindings and workflows.
;; https://github.com/bbatsov/crux
(use-package crux
  :ensure t
  :bind ([remap move-beginning-of-line] . crux-move-beginning-of-line))

;; Utilities to indent region.
;; Use > to indent right region and < to indent region left.
(defun my-indent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N 4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(defun my-unindent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N -4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(global-set-key ">" 'my-indent-region)
(global-set-key "<" 'my-unindent-region)

;; Unfill package has a reverse of fill-paragraph mode.
(use-package unfill
  :ensure t
  :bind ([remap fill-paragraph] . unfill-toggle))

;; Enable eldoc mode for elisp.
(add-hook 'emacs-lisp-mode-hook (lambda () (eldoc-mode t)))

(add-hook 'find-file-hook
		  (lambda()
			(highlight-phrase "\\(BUG\\|FIXME\\|TODO\\|NOTE\\):")))

;; Use ivy mode.
(use-package ivy
  :ensure t
  :bind (:map ivy-minibuffer-map
              ("<return>" . ivy-alt-done)
         :map global-map
              ("C-x b" . ivy-switch-buffer)
              ("C-x v" . ivy-push-view)
              ("C-x V" . ivy-pop-view))
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format  "(%d/%d) "
        ivy-extra-directories nil))

;; Use swiper.
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper-isearch)))

;; Use counsel, useful package.
(use-package counsel
  :ensure t
  :bind(("M-x" . counsel-M-x)
        ("C-x C-f" . counsel-find-file)
        ("M-y" . counsel-yank-pop)
        ("C-c g" . counsel-git)
        ("C-c c" . counsel-compile)
        ("C-c L" . counsel-git-log)
        ("C-c k" . counsel-rg)
        ("C-c o" . counsel-outline)))

;; Smart mode line
(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup))


(defun comment-or-uncomment-region-or-line ()
  "Like comment-or-uncomment-region, but if there's no mark \(that means no
region\) apply comment-or-uncomment to the current line"
  (interactive)
  (if (not mark-active)
      (comment-or-uncomment-region
       (line-beginning-position) (line-end-position))
    (if (< (point) (mark))
        (comment-or-uncomment-region (point) (mark))
      (comment-or-uncomment-region (mark) (point)))))

(global-set-key (kbd "C-c C-r") 'comment-or-uncomment-region-or-line)