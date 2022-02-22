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

(use-package use-package-ensure-system-package
  :ensure t)

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

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
  :bind (("s-g" . magit-status)
         ("C-x g" . magit-status))
  :config
  (use-package hl-todo
    :ensure t
    :config
    (hl-todo-mode))
  (setq
   magit-save-some-buffers nil
   magit-process-popop-time 10
   magit-diff-refine-hunk t
   magit-git-executable "/usr/bin/git"))

;; Use forge to interact with remote hosting site.
(use-package forge
  :ensure
  :after magit
  :config
  (setq auth-sources (quote (macos-keychain-internet macos-keychain-generic)))
  )



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

;; Don't put backup directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Setup some useful keybindings.
(global-set-key
 (kbd "C-<return>") 'other-window)
(define-key global-map [?\s-i] 'find-user-init-file)

;; Unset Ctrl-z when in descrete window.
(when window-system
  (global-unset-key [(control z)]))

;; Remove toolbar, menubar, scrollbar and tooltips
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-scroll-bar-mode 'nil)

;; Display settings
(add-to-list 'default-frame-alist '(width  . 89))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(font . "Inconsolata-11"))

(use-package rg
  :ensure t)

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
  :bind (:map projectile-mode-map
              ("C-c C-f" . projectile-find-file))
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

;; YAML mode is useful.
(use-package yaml-mode
  :ensure t
  :mode "\\.yaml\\'")

;; Configure my python dev environment.
(use-package elpy
  :ensure t
  :defer t
  :bind (:map elpy-mode-map
              ("M-." . elpy-goto-definition-or-rgrep))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (defalias 'workon 'pyvenv-workon)
  (defun elpy-goto-definition-or-rgrep ()
    "Go to the definition of the symbol at point, if found. Otherwise, run `elpy-rgrep-symbol'."
    (interactive)
    (ring-insert find-tag-marker-ring (point-marker))
    (condition-case nil (elpy-goto-definition)
      (error (elpy-rgrep-symbol
              (concat "\\(def\\|class\\)\s" (thing-at-point 'symbol) "(")))))
  (defun company-yasnippet-or-completion ()
    "Solve company yasnippet conflicts."
    (interactive)
    (let ((yas-fallback-behavior
           (apply 'company-complete-common nil)))
      (yas-expand)))

  (add-hook 'company-mode-hook
            (lambda ()
              (substitute-key-definition
               'company-complete-common
               'company-yasnippet-or-completion
               company-active-map))))

(use-package whitespace-cleanup-mode
  :ensure t
  :hook python-mode)


;; Utils to develop Rust.
(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package go-mode
  :ensure
  :config
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'gofmt-before-save nil 't))))

(use-package lsp-mode
  :ensure
  :commands lsp
  :hook go-mode
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
          ("C-n". company-select-next)
          ("C-p". company-select-previous)
          ("M-<". company-select-first)
          ("M->". company-select-last)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  (yas-global-mode 1))

(use-package flycheck
  :ensure
  :config
  (global-flycheck-mode 1))

(use-package exec-path-from-shell
  :ensure
  :config
  (when (daemonp)
    (exec-path-from-shell-initialize)))


(provide 'init)
;;; init.el ends here.
