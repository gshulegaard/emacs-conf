;;; package --- setup-rust: Configure rust settings

;;; Commentary:

;;; Code:

(use-package rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :custom
  (rust-indent-where-clause t)
  (rust-format-on-save t)
  (rust-format-show-buffer nil))

(provide 'setup-rust)
;;; setup-rust ends here
