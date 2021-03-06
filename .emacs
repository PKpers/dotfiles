;; Basic UI Configuration ----------------------------------------------

(defvar emacsclient/default-font-size 120)

(setq inhibit-startup-message t)
;;(setq default-directory "~/Desktop/4th_year")


(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar
(global-auto-revert-mode 1)
;; Set up the visible bell
(setq visible-bell t)

;; set up use package
(require 'package)
(setq package-archives '(("melpa". "https://melpa.org/packages/")
			 ("org".   "https://orgmode.org/elpa/")
			 ("elpa".  "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; set up line numbers mode
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist( mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		eshell-mode-hook
		pdf-view-mode-hook
		image-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(use-package doom-themes)
(load-theme 'doom-dracula t)

;; set some custom key bindings
(define-prefix-command 'ring-map)
(global-set-key (kbd "C-<SPC>") 'ring-map)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x n") 'visit-new-file)
(global-set-key (kbd "M-q") 'kill-ring-save)
(global-set-key (kbd "C-q") 'yank)
(global-set-key (kbd "C-<SPC> k") 'next-buffer)
(global-set-key (kbd "C-<SPC> j") 'previous-buffer)
(global-set-key (kbd "C-x e") 'eval-buffer)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-collection/" user-emacs-directory))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6))
  ;;(:exec (list conda-env-current-name)) 

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(defhydra hydra-buffer-switch (:timeout 4)
  "cycle through buffers"
  ("j" previous-buffer "prev")
  ("k" next-buffer "next")
  ("f" nil "finished" :exit t))

(defun prev-window ()
  (interactive)
  (other-window -1))

(defhydra hydra-window-switch (:timeout 4)
  "cycle through windows"
  ("j" prev-window "prev") 
  ("k" other-window "next")
  ("f" nil "finished" :exit t))

(defhydra hydra-window-resize (:timeout 4)
  "resize windows"
  ("j" enlarge-window "enlarge vert") 
  ("k" shrink-window "shrink vertical")
  ("h" enlarge-window-horizontally "enlarge horiz") 
  ("l" shrink-window-horizontally "shrink horiz")
  ("f" nil "finished" :exit t))


(rune/leader-keys
  "z" '(hydra-text-scale/body :which-key "scale text")
  "b"  '(hydra-buffer-switch/body :which-key "change buffer")
  "w" '(hydra-window-switch/body :which-key "change-window")
  "r" '(hydra-window-resize/body :which-key "resize window"))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))
 
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Doesnt start seatches with ^

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-fvariable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable]. counsel-describe-variable)
  ([remap describe-key] . helpful-key))

 
;; Font Configuration -------------------------------------------------
(add-to-list 'default-frame-alist '(font . "FiraCodeRetina-12.5")) ; global font

; Use open dyslexic font faces in prog mode
(defun my-buffer-face-mode-dyslexic ()
  "set open dyslexic as the font in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "OpenDyslexic Nerd Font" :height 120 :width semi-condensed))
  (buffer-face-mode))
(add-hook 'prog-mode-hook 'my-buffer-face-mode-dyslexic)

;OpenDyslexic Nerd Font
;;Package Manager Configuration ---------------------------------------
;; initialize package sources

;; PDF files-------------------------------------------------------------
;; somehow pdf-tools is broken. Untill its fixed I will use mupdf as emacs default pdf reader with the use of open with package
(use-package openwith)
(require 'openwith)
(setq openwith-associations '(("\\.pdf\\'" "mupdf" (file))))
(openwith-mode t)
;(use-package pdf-tools
;  :pin manual
;  :config
 ; (pdf-tools-install)
 ; (setq-default pdf-view-display-size 'fit-width); open a pdf in pdf-view mode
 ; (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward); use isearch
 ; :custom
  ;(pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; Conda configuration-------------------------------------------------
(use-package conda)
(require 'conda)
;; if you want interactive shell support, includee
(conda-env-initialize-interactive-shells)
;; if you want eshell support, include:
(conda-env-initialize-eshell)
;; if you want auto-activation (see below for details), include:
;;(conda-env-autoactivate-mode t)
(setq-default mode-line-format (cons '(:exec conda-env-current-name) mode-line-format))
(setq conda-env-home-directory
      (expand-file-name "~/miniconda3/")
      conda-env-subdirectory "envs")


;; variables added by custom -------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(conda-anaconda-home "~/miniconda3/")
 '(counsel-mode t)
 '(custom-safe-themes
   '("234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" default))
 '(doc-view-continuous t)
 '(ivy-rich-mode t)
 '(package-selected-packages
   '(openwith hydra evil-collection evil-mc-extras evil elfeed pdf-tools perspective pdf-view-restore flyspell-correct-ivy vterm eshell-prompt-extras eshell-git-prompt visual-fill-column org-bullets conda exec-path-from-shell helpful which-key use-package doom-themes doom-modeline counsel auto-correct))
 '(visual-line-mode t t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Org Mode Configuration ------------------------------------------------

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  '(indent-tabs-mode 0)
  '(org-src-preserve-indentation 0)
  )


(defun efs/org-font-setup ()
  ;;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "???")))))))

;; Set faces for heading levels
(with-eval-after-load 'org-faces
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ???"
	org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("???" "???" "???" "???" "???" "???" "???")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fil-comlumn-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; ehsell prompt config -----------------------------------------------
(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

;(use-package eshell-git-prompt)

;(use-package eshell
;  :hook (eshell-first-time-mode . efs/configure-eshell)
;  :config
;  (with-eval-after-load 'esh-opt
;    (setq eshell-destroy-buffer-when-process-dies t)
;    (setq eshell-visual-commands '("htop" "zsh" "vim")))

 ; (eshell-git-prompt-use-theme 'default))
;; org export to latex conifg----------------------------------------
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

;;Vterm configuration------------------------------
(use-package vterm
  :commands vterm
  :config
  (setq vterm-timer-delay 0)
)
;; Managing mail with mu4e-----------------------------------------
(use-package mu4e
  :ensure nil
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :defer 20 ; Wait until 20 seconds after startup
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")
  
  (setq mu4e-contexts
        (list
         ;; Personal account
         (make-mu4e-context
          :name "Personal"
          :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "dinogreco2000@gmail.com")
                  (user-full-name    . "Kostas Papadimos Gmail")
                  (mu4e-drafts-folder  . "/Gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/Gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")))))

  (setq org-capture-templates
	`(("m" "Email Workflow")
	  ("mf" "Follow Up" entry (file+headline "~/org/Mail.org" "Follow Up")
           "* TODO %a\n\n  %i")
	  ("mr" "Read Later" entry (file+headline "~/org/Mail.org" "Read Later")
           "* TODO %a\n\n  %i")))  

  (setq mu4e-maildir-shortcuts
      '(("/Gmail/Inbox"             . ?i)
        ("/Gmail/[Gmail]/Sent Mail" . ?s)
        ("/Gmail/[Gmail]/Trash"     . ?t)
        ("/Gmail/[Gmail]/Drafts"    . ?d)
        ("/Gmail/[Gmail]/All Mail"  . ?a)))
  ;; Run mu4e in the background to sync mail periodically
  (mu4e t))
;; use org mode with mail 
(require 'mu4e-org)

;; I hope that this will make org mode to evaluate python code
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;; Set up elfeed, an emacs rss feed vewer--------------------------------------------------------------------
(use-package  elfeed)
(setq elfeed-feeds
      '(("https://bbs.archlinux.org/extern.php?action=feed&type=atom" blog arch)
	("feeds.feedburner.com/euronews/en/home/" europe news)
	("https://www.espn.com/espn/rss/nba/news" nba news)
	("https://feeds.feedburner.com/kathimerini/DJpy" greece news)
	("https://rss.app/feeds/6oyQGIYogYvz0ZbZ.xml" dt youtube linux)
	("https://rss.app/feeds/mQn3p8gZkR4pJULB.xml" ls youtube linux society)
	("https://rss.app/feeds/7D7jSUsTLqaak2Hb.xml" mo youtube linux society)
	("https://rss.app/feeds/3xc8sQETJzH96ABV.xml" ct youtube linux tech)
	("https://www.youtube.com/c/JordanPetersonVideos" jp politics psychology)
	("https://rss.app/feeds/f3hq9KWdnnhUx88o.xml" rl music composing)
	("https://rss.app/feeds/u1j1RiyI51ZpTosP.xml" an music )
	("https://politis.com.cy/feed/" cyprus news)))
(global-set-key (kbd "C-x w") 'elfeed)
