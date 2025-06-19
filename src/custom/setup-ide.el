;;; package --- setup-ide: Configure basic IDE settings

;;; Commentary:

;;; Code:

;;    Flycheck
;;    Flycheck (aka "Flymake done right") is a modern on-the-fly sytax checking
;;    extension for GNU emacs24.

(use-package flycheck
  :straight t)
(add-hook 'after-init-hook #'global-flycheck-mode)
(global-set-key (kbd "C-c C-n") 'flycheck-next-error)
(global-set-key (kbd "C-c C-p") 'flycheck-prev-error)

;;    lsp-mode

(use-package lsp-mode
  :straight t)

;;    smartparens

(use-package smartparens
  :straight t)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;;    Neotree
;;    Neotree is a file browsing extension.  It can be used to provide a
;;    directory map similar to most IDE side bars/project file map.

(use-package neotree
  :straight t)
(global-set-key (kbd "<C-tab>") 'neotree)
;; This won't work in terminal because TAB itself is the control sequence C-i

;; disable linum for neotree
(defun my/neotree-hook (_unused)
  (display-line-numbers-mode 0))

(add-hook 'neo-after-create-hook 'my/neotree-hook)

;; automatically indent when press RET

(global-set-key (kbd "RET") 'newline-and-indent)

;; activate whitespace-mode to view all whitespace characters

(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff

(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; Package: clean-aindent-mode
;; Now when you hit newline you will get appropriate whitespace for indenting,
;; but if you leave the line blank and move to the next line, the whitespace
;; becomes useless.  This package helps clean up unused whitespace.

(use-package clean-aindent-mode
  :straight t)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: dtrt-indent
;; A minor mode that guesses the indentation offset originally used for
;; creating source code files and transparently adjusts the corresponding
;; settings in Emacs, making it more convenient to edit foreign files.

(use-package dtrt-indent
  :straight t)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)

(provide 'setup-ide)
;;; setup-ide.el ends here
