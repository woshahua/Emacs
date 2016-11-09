
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)


;;close tool bar
(tool-bar-mode -1)

;;close scroll bar
(scroll-bar-mode -1)

;;show the line number
(global-linum-mode 1)

;;close help screen
(setq inhibit-splash-screen 1)

;;change font size to 16pt
(set-face-attribute 'default nil :height 160)

;;quick-open config file
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;;set open-init-file to key F2
(global-set-key (kbd"<f2>") 'open-init-file)
;;set other window key
(global-set-key (kbd"C-t") 'other-window)
;;set easy kill
(global-set-key (kbd"M-w") 'easy-kill)


;;取消生成emacs配置文件
(setq make-backup-files nil)

;;open recent file in a GUI mode
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

(delete-selection-mode 1)

;;set emacs to full screen
(setq initial-frame-alist (quote((fullscreen . maximized))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-recentf helm-source-files-in-current-dir helm-source-emacs-commands-history helm-source-emacs-commands)))
 '(package-selected-packages
   (quote
    (smart-shift w3m easy-kill silkworm-theme dired-toggle which-key helm flycheck ein elpy js3-mode jedi python-mode smartparens nodejs-repl js2-mode hungry-delete exec-path-from-shell counsel company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-hl-line-mode 1)
(load-theme 'silkworm 1)
(setq org-agenda-files '("~/org"))
(global-set-key (kbd "C-c a") 'org-agenda)

(require 'org)
(setq org-src-fontify-natively t)

;;java script ide js3
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist))
;;set meta key to command key useful in mac
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)


;;setting for the jedi python
(require 'epc)
(require 'auto-complete-config)
(require 'python)

;;;;; PYTHONPATH上のソースコードがauto-completeの補完対象になる ;;;;;
(setenv "PYTHONPATH" "/usr/local/lib/python3.5/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


;;set elpy path
(setq elpy-rpc-python-command "python3")
(elpy-enable)
(elpy-use-ipython)


;;set flycheck for python
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;set key for Dired
(global-set-key (kbd "S-<f1>")
		(lambda()
		  (interactive)
		  (dired "~/")))


;;fix ipython 5 bug for emacs
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")

;;Helm setting
(require 'helm-config)
(helm-mode 1)

(add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))

(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

(defvar helm-source-emacs-commands
  (helm-build-sync-source "Emacs commands"
    :candidates (lambda ()
                  (let ((cmds))
                    (mapatoms
                     (lambda (elt) (when (commandp elt) (push elt cmds))))
                    cmds))
    :coerce #'intern-soft
    :action #'command-execute)
  "A simple helm source for Emacs commands.")

(defvar helm-source-emacs-commands-history
  (helm-build-sync-source "Emacs commands history"
    :candidates (lambda ()
                  (let ((cmds))
                    (dolist (elem extended-command-history)
                      (push (intern elem) cmds))
                    cmds))
    :coerce #'intern-soft
    :action #'command-execute)
  "Emacs commands history")



(define-key global-map (kbd "C-;") 'helm-mini)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;;enable which key
(which-key-mode 1)


;;smart shift
(global-smart-shift-mode 1)
;;; markがないときはエラーになるバグがあるので修正
(defadvice smart-shift-lines (before mark-fix activate)
  (or (mark) (push-mark nil t)))

(global-set-key (kbd"C-x C-f") 'helm-find-files)
(global-set-key (kbd"M-x") 'helm-M-x)

