;;; package --- setup-markdown.el: Configure markdown support

;;; Commentary:

; https://jblevins.org/projects/markdown-mode/

;;; Code:

(use-package markdown-mode
  :straight t)
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(provide 'setup-markdown)
;;; setup-markdown.el ends here
