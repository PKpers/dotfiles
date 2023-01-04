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

;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-collection/" user-emacs-directory))
(use-package evil-collection
  :load-path "~/.emacs.d/evil-collection/"
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

;; Configure spelling ----------------------------------------------------------------------------------------------------
(require 'ispell)
(setenv
 "DICPATH"
 "/usr/share/hunspell")
;;
(add-to-list 'ispell-local-dictionary-alist '("greek-hunspell"
                                              "[[:alpha:]]"
                                              "[^[:alpha:]]"
                                              "[']"
                                              t
                                              ("-d" "el_GR"); Dictionary file name
                                              nil
                                              iso-8859-1))

(add-to-list 'ispell-local-dictionary-alist '("english-hunspell"
                                              "[[:alpha:]]"
                                              "[^[:alpha:]]"
                                              "[']"
                                              t
                                              ("-d" "en_US")
                                              nil
                                              iso-8859-1))

(setq ispell-program-name "hunspell"          ; Use hunspell to correct mistakes
      ispell-dictionary   "en_US") ; Default dictionary to use

(defun  fd-switch-dictionary()
  "Switch greek and english dictionaries."
  (interactive)
  (let* ((dict ispell-current-dictionary)
	 (new (if (string= dict "el_GR") "en_US"
		"el_GR")))
    (ispell-change-dictionary new)
    (message "Switched dictionary from %s to %s" dict new)))

(global-set-key (kbd "<f8>") 'fd-switch-dictionary)
(add-hook 'org-mode-hook 'turn-on-flyspell)
;; PDF files-------------------------------------------------------------
;; somehow pdf-tools is broken. Untill its fixed I will use mupdf as emacs default pdf reader with the use of open with package
(use-package openwith)
(require 'openwith)
(setq openwith-associations '(("\\.pdf\\'" "mupdf" (file))
			       ("\\.odp\\'" "libreoffice " (file))))
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
;(use-package conda)
;(require 'conda)
;; if you want interactive shell support, includee
;(conda-env-initialize-interactive-shells)
;; if you want eshell support, include:
;(conda-env-initialize-eshell)
;; if you want auto-activation (see below for details), include:
;;(conda-env-autoactivate-mode t)
;(setq-default mode-line-format (cons '(:exec conda-env-current-name) mode-line-format))
;(setq conda-env-home-directory
;      (expand-file-name "~/miniconda3/")
;      conda-env-subdirectory "envs")


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
   '(org-mime dired-hide-dotfiles dired-single openwith hydra evil-collection evil-mc-extras evil elfeed pdf-tools perspective pdf-view-restore flyspell-correct-ivy vterm eshell-prompt-extras eshell-git-prompt visual-fill-column org-bullets conda exec-path-from-shell helpful which-key use-package doom-themes doom-modeline counsel auto-correct))
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
  (visual-line-mode 1)
  )


(defun efs/org-font-setup ()
  ;;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

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
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t)
  
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq agenda-dir "~/Documents/Agenda/")
  (setq org-agenda-files  (list agenda-dir))
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
	'(("d" "Dashboard"
	   ((agenda "" ((org-deadline-warning-days 7)))
	    (todo "NEXT"
		  ((org-agenda-overriding-header "Next Tasks")))
	    (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
	  
	  ("n" "Next Tasks"
	   ((todo "NEXT"
		  ((org-agenda-overriding-header "Next Tasks")))))
	  
	  ("W" "Work Tasks" tags-todo "+work-email")
	  
	  ;; Low-effort next actions
	  ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
	   ((org-agenda-overriding-header "Low Effort Tasks")
	    (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))
	  
	  ("w" "Workflow Status"
	   ((todo "WAIT"
		  ((org-agenda-overriding-header "Waiting on External")
		   (org-agenda-files org-agenda-files)))
	    (todo "REVIEW"
		  ((org-agenda-overriding-header "In Review")
		   (org-agenda-files org-agenda-files)))
	    (todo "PLAN"
		  ((org-agenda-overriding-header "In Planning")
		   (org-agenda-todo-list-sublevels nil)
		   (org-agenda-files org-agenda-files)))
	    (todo "BACKLOG"
		  ((org-agenda-overriding-header "Project Backlog")
		   (org-agenda-todo-list-sublevels nil)
		   (org-agenda-files org-agenda-files)))
	    (todo "READY"
		  ((org-agenda-overriding-header "Ready for Work")
		   (org-agenda-files org-agenda-files)))
	    (todo "ACTIVE"
		  ((org-agenda-overriding-header "Active Projects")
		   (org-agenda-files org-agenda-files)))
	    (todo "COMPLETED"
		  ((org-agenda-overriding-header "Completed Projects")
		   (org-agenda-files org-agenda-files)))
	    (todo "CANC"
		  ((org-agenda-overriding-header "Cancelled Projects")
		   (org-agenda-files org-agenda-files)))))))
  ;; setuo org capture templates 
  (setq org-capture-templates
	`(("t" "Tasks / Projects")
	  ("tt" "Task" entry (file+olp "~/Documents/Agenda/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
	  
	  ("ts" "Shoping List" entry (file+olp "~/Documents/Agenda/Shoping_list.org" "Additions")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
	   
	   ("j" "Journal Entries")
	   ("jj" "Journal" entry
            (file+olp+datetree "~/Documents/Agenda/Journal.org")
            "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
            ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
            :clock-in :clock-resume
            :empty-lines 1)
	   ("jm" "Meeting" entry
            (file+olp+datetree "~/Documents/Agenda/Journal.org")
            "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
            :clock-in :clock-resume
            :empty-lines 1)
	   
	   ("w" "Workflows")
	   ("we" "Checking Email" entry (file+olp+datetree "~/Documents/Agenda/Journal.org")
            "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
	   
	   ("m" "Metrics Capture")
	   ("mw" "Weight" table-line (file+headline "~/Documents/Agenda/Metrics.org" "Weight")
	    "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t))))
  

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
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
(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
;; CV template
(add-to-list 'org-latex-classes
	     '("CV"
	       "\\documentclass[margin, 10pt]{res}
\\usepackage{helvet} % Default font is the helvetica postscript font
\\setlength{\\textwidth}{5.1in} % Text width of the document"
	       ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))
;; Test CV template
(add-to-list 'org-latex-classes
	     '("CVTest"
	       "\\documentclass{resume} % Use the custom resume.cls style
\\usepackage{carlito} % Default font is the helvetica postscript font
\\renewcommand{\\familydefault}{\\sfdefault}
\\usepackage[left=0.4 in,top=0.4in,right=0.4 in,bottom=0.4in]{geometry} % Document margins
\\newcommand{\\tab}[1]{\\hspace{.2667\\textwidth}\\rlap{#1}} 
\\newcommand{\\itab}[1]{\\hspace{0em}\\rlap{#1}}
\\name{Konstantinos Papadimos} % Your name
% You can merge both of these into a single line, if you do not have a website.
\\address{+357-96504365, +30-6947651059}
\\address{papadimos.konstantinos@ucy.ac.cy}
\\begin{Document}
"
	       ("\\rSection{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))
 ;; Article template
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage{subfiles}
\\usepackage{algorithm}
\\usepackage{minted}
\\usepackage{xcolor}
\\usepackage[utf8]{inputenc}
\\usepackage{gentium}
\\usepackage{graphicx}
\\usepackage{grffile}
\\usepackage{longtable}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{amssymb}
\\usepackage{capt-of}
\\usepackage{hyperref}
\\usepackage[greek]{babel}
\\usepackage{multicol}
\\usepackage[framemethod=tikz]{mdframed}
\\usepackage[compact]{titlesec}
\\usepackage{float}
\\titlespacing{\section}{0pt}{*0}{*0}
\\titlespacing{\subsection}{0pt}{*0}{*0}
\\titlespacing{\subsubsection}{0pt}{*0}{*0}
\\usepackage{geometry} % Required for adjusting page dimensions and margins
\\geometry{
	paper=a4paper, % Paper size, change to letterpaper for US letter size
	top=2.5cm, % Top margin
	bottom=3cm, % Bottom margin
	left=2.5cm, % Left margin
	right=2.5cm, % Right margin
	headheight=14pt, % Header height
	footskip=1.5cm, % Space from the bottom margin to the baseline of the footer
	headsep=1.2cm, % Space from the top margin to the baseline of the header
	%showframe, % Uncomment to show how the type block is set on the page
}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))
;;Vterm configuration-----------------------------------------------
(use-package vterm
  :commands vterm
  :config
  (setq vterm-timer-delay 0)
)
;; Managing mail with mu4e-----------------------------------------
(use-package mu4e
  :ensure nil
  :defer 20 ; Wait until 20 seconds after startup
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")
  ;; Configure the function to use for sending mail
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq smtpmail-queue-mail nil)
  ;; Make sure plain text mails flow correctly for recipients
  (setq mu4e-compose-format-flowed t)
 ;; prevent <openwith> from interfering with mail attachments
  (require 'mm-util)
  (add-to-list 'mm-inhibit-file-name-handlers 'openwith-file-handler)
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
                  (user-full-name    . "Kostas Papadimos")
		  (smtpmail-smtp-server  . "smtp.gmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type  . ssl)
                  (mu4e-drafts-folder  . "/Gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/Gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")))))
  
  (setq org-capture-mail-templates
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
;; use org mode to compose emails 
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/org-mime/" user-emacs-directory))
;;(require 'org-mime)
(use-package org-mime
  :load-path "~/.emacs.d/org-mime")
;; Configure the org-export template  
(setq org-mime-export-options '(:section-numbers nil
						 :with-author nil
						 :with-toc nil))
;; format the look of the code blocs inside mail 
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                           "#E6E1DC" "#232323"))))
;; automatically convert messages to org before sending them 
(add-hook 'message-send-hook 'org-mime-htmlize)
;; I hope that this will make org mode to evaluate python code-------------------------------------------
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;; Set up elfeed, an emacs rss feed vewer--------------------------------------------------------------------
(use-package  elfeed)
(setq elfeed-feeds
      '( ("https://archlinux.org/feeds/news/" ArchLinux news)
	("https://physics.stackexchange.com/feeds" Physics StackExchange)
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
	("http://feeds.aps.org/rss/prdsuggestions.xml" PRD suggestions)
	("http://feeds.aps.org/rss/recent/prlsuggestions.xml" PRL suggestions)
	("http://feeds.aps.org/rss/allsuggestions.xml" APS sugestions)
	("https://politis.com.cy/feed/" cyprus news)))
(global-set-key (kbd "C-x w") 'elfeed)
;; Customise dired ----------------------------------------------------------------------------------------------------
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
   "h" 'dired-up-directory
   "l" 'dired-find-file))
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/dired-single/" user-emacs-directory))
;;(require 'dired-single)
(use-package dired-single
  :load-path "~/.emacs.d/dired-single/"
  )
(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))
;;define a major mode for dict files------------------------------------------------------------------------------------
;; create the list for font-lock.
;; each category of keyword is given a particular face

(setq mdict-font-lock-keywords
      (let* (
            ;; define several category of keywords
            (x-keywords '("With" "keys" "items"))
            (x-types '("float" "int"  "str" "bin" "Mixed"))

            ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words))
            (x-types-regexp (regexp-opt x-types 'symbols)))
        `(
	  ("#\\|" . font-lock-comment-face )
	  ;;("!\\|" . font-lock-type-face)
	  ("=\\|" . font-lock-constant-face)
	  ("\\([[0-9a-zA-Z_]+\\)]" . font-lock-function-name-face)
	  ("/!(\w)+/g" . font-lock-constant-face)
	  ;;("\\([a-zA-Z_]+\\)=" . font-lock-constant-face)
          (,x-types-regexp . 'font-lock-type-face)
          (,x-keywords-regexp . 'font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;;;###autoload
(define-derived-mode mdict-mode conf-mode "dict mode"
  "Major mode for editing dict files"
  ;; code for syntax highlighting
  (setq font-lock-defaults '((mdict-font-lock-keywords))))
;; add the mode to the `features' list
(provide 'mdict-mode)
;;; mylsl-mode.el ends here
(add-to-list 'auto-mode-alist '("\\.dict\\'" . mdict-mode))
