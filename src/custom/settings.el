;;; package --- settings.el: Basic Emacs settings

;;; Commentary:

;;; Code:

;;    Turn off scrollbars...
;;    You can toggle scroll bars with `M-x scroll-bar-mode`.

(scroll-bar-mode -1)

;;    Tab settings...
;;    No tab characters - nor anytime wasting mysteries about tabs
;;    vs. characters (e.g. GNU Make Makefiles!).

(setq-default indent-tabs-mode nil)
(setq-default standard-indent 4)
(setq-default tab-stop-list (number-sequence 4 200 4))
(setq-default tab-width 4)

;;    Line Numbers...

(global-linum-mode t)

(defun my/disable-linum-hook ()
  (linum-mode -1))

(add-hook 'term-mode-hook 'my/disable-linum-hook)
(add-hook 'ansi-term-mode-hook 'my/disable-linum-hook)

;;    Column Numbers...

(column-number-mode t)

;;    Display time on the mode line.

(display-time-mode 1)

;;    Display date and time on the mode line (instead of just time).
;;    This must be used in conjunction with display-time-mode and will not work
;;    simply on its own.

(setq display-time-day-and-date 1)

;;    Title Bar settings...
;;    http://emacs-fu.blogspot.com/2011/01/setting-frame-title.html

;; (setq frame-title-format
;;   '((:eval (user-login-name)) "%@"
;;     (:eval (system-name)) ": " "%F" " %[^%]"))

(setq frame-title-format nil)

;;    AutoFillMode -- Inserts line ending after last word to finish before
;;    specified fill-column number.  Default column length is 70.  Options are
;;    included here foreasy configuration.

;;    AutoFillMode is buffer specific, so you can turn it on per major mode via
;;    "add-hook".

;(add-hook 'text-mode-hook 'turn-on-auto-fill (set-fill-column 80))
;(add-hook 'emacs-list-mode-hook 'turn-on-auto-fill (set-fill-column 80))

;;     Alternatively, you can turn on AutoFillMode globally and disable it for
;;     specific major modes with "add-hook".  An example of how to turn off
;;     AutoFillMode for specific major mode buffers is included (but commented
;;     out).

(setq-default fill-column 80)
(setq-default auto-fill-function 'do-auto-fill)
(setq auto-fill-mode nil)

;;     Disable AutoFillMode here...

;(add-hook 'text-mode-hook 'turn-off-auto-fill)

;;    Line wrapping...
;;    Personally, I hate visual line wrappers since they can dramatically impact
;;    the appearance of a file.  Instead, I use truncate lines by default.

(set-default 'truncate-lines t)

;;    You can manually enable VisualLineMode by using 'M-x visual-line-mode'.
;;    If you dislike TruncateLineMode, you can comment out the above line.
;;    emacs24 enables VisualLineMode by default.

;;    Set emacs to save buffers on exit.

(require 'desktop)
(desktop-save-mode 1)
(defun my-desktop-save () (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a
  ;; message.
  (if (eq(desktop-owner) (emacs-pid))
    (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)

;;; Adopted nano defaults
;;; https://github.com/rougier/nano-emacs/blob/master/nano-defaults.el


;; No startup  screen
(setq inhibit-startup-screen t)

;; No startup message
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;; No frame title
(setq frame-title-format nil)

;; No file dialog
(setq use-file-dialog nil)

;; No dialog box
(setq use-dialog-box nil)

;; No popup windows
(setq pop-up-windows nil)

;; No empty line indicators
(setq indicate-empty-lines nil)

;; No cursor in inactive windows
(setq cursor-in-non-selected-windows nil)

;; No confirmation for visiting non-existent files
(setq confirm-nonexistent-file-or-buffer nil)

;; Completion style, see
;; gnu.org/software/emacs/manual/html_node/emacs/Completion-Styles.html
(setq completion-styles '(basic substring))

;; Use RET to open org-mode links, including those in quick-help.org
(setq org-return-follows-link t)

;; Mouse active in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; No scroll bars
(scroll-bar-mode -1)
;; (if (fboundp 'scroll-bar-mode) (set-scroll-bar-mode nil))

;; No toolbar
(tool-bar-mode -1)
;; (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; No menu bar
(menu-bar-mode -1)
;; (if (display-graphic-p)
;;     (menu-bar-mode t) ;; When nil, focus problem on OSX
;;   (menu-bar-mode -1))

;; Mac specific
(when (eq system-type 'darwin)
  (setq ns-use-native-fullscreen t
        mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier 'meta
        mac-option-modifier nil
        mac-use-title-bar nil))

;; Make sure clipboard works properly in tty mode on OSX
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
(when (and (not (display-graphic-p))
           (eq system-type 'darwin))
    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx))

;; y/n for  answering yes/no questions
(fset 'yes-or-no-p 'y-or-n-p)

;; Buffer encoding
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   'utf-8)

;; Default shell in term
(unless
    (or (eq system-type 'windows-nt)
        (not (file-exists-p "/bin/bash")))
  (setq-default shell-file-name "/bin/bash")
  (setq explicit-shell-file-name "/bin/bash"))

; Kill term buffer when exiting
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

(provide 'settings)
;;; settings.el ends here
