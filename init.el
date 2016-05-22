;; Emacs Configuration
;; Author: Vickey Singh <vickey@helpshift.com

(setq mac-command-modifier 'meta)
(setq ispell-program-name "/usr/local/bin/aspell")

;; Configuring load-path 
(add-to-list 'load-path "~/.emacs.d/elpa/use-package-2.1/")
(add-to-list 'load-path "~/.emacs.d/elpa/bind-key-2.1/")
(add-to-list 'load-path "~/usr/local/bin/")

(require 'package)
(require 'use-package)

;; Archive to download packages
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))


(package-initialize)

;; Packages to be installed

(defvar packages-list
  '(better-defaults
    auto-complete
    magit
    projectile
    flx-ido
    smart-mode-line
    bind-key
    diff-hl
    git-gutter
    diminish
    use-package
    yasnippet
    aggressive-indent
    smartparens
    rainbow-delimiters
    paredit
    company
    clj-refactor
    autopair
    clojure-mode))


;;; User information

(setq user-full-name "Vickey")
(setq user-mail-address "vickey@helpshift.com")


(package-refresh-contents)

(defun init-install-packages ()
  (dolist (p packages-list)
  (when (not (package-installed-p p))
    (package-install p))))

(init-install-packages)


;;; Enable auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; Toggle to fullscreen on start
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;;; Jump direclty onto the scratch buffer
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'clojure-mode)

;; Set font size
(set-face-attribute 'default nil :height 140)

;;; Backup file
(setq make-backup-files nil)


(require 'autopair)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t
      ido-use-faces nil
      ido-use-virtual-buffers t)

(setq column-number-mode t)

;; Load clojure snippets
(when (require 'yasnippet nil 'noerror)
  (progn
    (yas/load-directory "~/.emacs.d/snippets")))
(yas-global-mode 1)

;;; Load theme zenburn
(load-theme 'zenburn t)

;; clj-refactor
(require 'clj-refactor)

(defun clj-refactor-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m"))

;; Settings for git gutter
(require 'git-gutter)
(global-git-gutter-mode t)
(custom-set-variables
 '(git-gutter:window-width 2)
 '(git-gutter:modified-sign "☁")
 '(git-gutter:added-sign "☀")
 '(git-gutter:deleted-sign "☂"))

;; Settings for cider

(setq nrepl-log-messages nil)
(setq nrepl-hide-special-buffers t)
(setq cider-prefer-local-resources t)
(setq cider-prompt-save-file-on-load nil)
(setq cider-eval-result-prefix ";; => ")
(setq cider-font-lock-dynamically '(macro core function var))
(setq cider-overlays-use-font-lock t)
(setq nrepl-hide-special-buffers t)
(setq cider-show-error-buffer 'only-in-repl)
(setq cider-stacktrace-default-filters '(tooling dup))
(setq cider-stacktrace-fill-column 80)
(setq nrepl-buffer-name-show-port t)
(setq cider-repl-display-help-banner nil)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file "~/cider/history.dat")


;;; Hooks

;; Company mode
(add-hook 'after-init-hook 'global-company-mode)

;; diff-hl
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-checkin-hook 'diff-hl-update)

;; cider

(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'company-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'smartparens-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)


(require 'smartparens-config)
(eval-after-load 'clojure-mode '(progn (add-hook 'clojure-mode-hook #'paredit-mode)
                                       (add-hook 'clojure-mode-hook #'subword-mode)
                                       (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
                                       (add-hook 'clojure-mode-hook #'smartparens-mode)
                                       (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
                                       (add-hook 'clojure-mode-hook #'flyspell-prog-mode)
                                       (add-hook 'clojure-mode-hook #'clj-refactor-hook)
                                       (add-hook 'clojure-mode-hook #'git-gutter-mode)))



(defface my-outermost-paren-face '((t (:weight bold)))
  "Face used for outermost parens.")

(defface my-inner-paren-face '((((class color) (background dark))
                                (:foreground "grey50"))
                               (((class color) (background light))
                                (:foreground "grey55")))
  "Face used to dim inner parentheses.")

;; Utility functions

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))


(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((/= (count-windows) 2)
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1))))
  (other-window 1))


;; Key Bindings

(bind-key "C-x C-b" 'ibuffer)
(bind-key "C-c s" 'swap-windows)
(bind-key "C-7" 'comment-or-uncomment-region-or-line)
(bind-key "C-j" 'newline-and-indent)
(bind-key "M-+" 'text-scale-increase)
(bind-key "M-_" 'text-scale-decrease)
(bind-key "M-k" 'kill-this-buffer)
(bind-key "C-x g" 'magit-status)
(bind-key "M-." 'find-function-at-point)
(bind-key "C->" 'mc/mark-next-like-this)
(bind-key "C-<" 'mc/mark-previous-like-this)
(bind-key "C-c C-<" 'mc/mark-all-like-this)
(bind-key "M-s d" 'projectile-find-dir)
(bind-key "M-s p" 'projectile-switch-project)
(bind-key "M-s f" 'projectile-find-file)
(bind-key "M-s g" 'projectile-grep)

(bind-key
 "C-x C-c"
 (lambda ()
   (interactive)
   (if (y-or-n-p "Quit Emacs? ")
       (save-buffers-kill-emacs))))


;; Alias

(defalias 'yes-or-no-p 'y-or-n-p)

;; For smart mode line
(setq sml/theme 'respectful)
(setq sml/no-confirm-load-theme t)
(sml/setup)

;; Change highlight text color
;; goldenrod = #DAA520
;; golden = #FFD700
;; Aureolin = #FDEE00
(set-face-attribute 'region nil :background "#DAA520" :foreground "#000")

;; for speeding up file lookup
(projectile-global-mode 1)
(setq projectile-enable-caching t)
(setq projectile-require-project-root nil)
(setq projectile-completion-system 'ido)

