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

(provide 'setup-python)
;;; setup-python.el ends here
