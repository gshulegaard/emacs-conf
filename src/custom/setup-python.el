;;; package --- setup-ide: Configure basic IDE settings

;;; Commentary:

;;; Code:

;;;   Python Editing

;;     set python interpreter to python3
(setq python-shell-interpreter "python3")


;;    flycheck settings (set to python3 by default)
;;    https://stackoverflow.com/questions/37720869/emacs-how-do-i-set-flycheck-to-python-3

(custom-set-variables
  '(flycheck-python-pycompile-executable "python3")
  '(flycheck-python-flake8-executable "python3")
  '(flycheck-python-pylint-executable "python3"))

;;    flycheck-pychecker (typehinting enable)

;(use-package flycheck-pycheckers
;  :straight t)
;(require 'flycheck-pycheckers)

;(add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup)

;(setq flycheck-pycheckers-checkers
;      '(mypy3 pyflakes))

;;    lsp
;; https://github.com/doomemacs/doomemacs/tree/develop/modules/tools/lsp

(add-hook 'python-mode-hook #'lsp-deferred)

;;    lsp-pyright

(use-package lsp-pyright
  :straight t)

;; pyvenv

(use-package pyvenv
  :straight t
  :ensure t
  :init
  (setenv "WORKON_HOME" "./venv/")
  :config
  ;; (pyvenv-mode t)

  ;; Set correct Python interpreter
  (setq pyvenv-post-activate-hooks
        (list (lambda ()
                (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python")))))
  (setq pyvenv-post-deactivate-hooks
        (list (lambda ()
                (setq python-shell-interpreter "python3")))))

;; Setup some python-mode hooks
;; https://github.com/daviwil/emacs-from-scratch/wiki/LSP-Python-(pyright)-config-in-emacs-from-scratch#python-mode

(use-package python-mode
  :straight t
  :hook
  (python-mode . pyvenv-mode)
  (python-mode . flycheck-mode)
  (python-mode . company-mode)
  ;(python-mode . blacken-mode)
  ;(python-mode . yas-minor-mode)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  (python-shell-interpreter "python3")
  :config
  )

(provide 'setup-python)
;;; setup-python.el ends here
