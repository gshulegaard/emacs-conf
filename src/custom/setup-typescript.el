;;; package --- setup-typescript.el: Setup TypeScript

;;; Commentary:

;;; Code:

;;;   TypeScript packages

(use-package typescript-mode
  :straight t)

;; default typescript indent level
(setq-default typescript-indent-level 2)

;; company (COMplete ANYthing)
;; http://company-mode.github.io/
;; This is an optional dependency for TIDE

(use-package company
  :straight t)

;;    TIDE
;;    http://redgreenrepeat.com/2018/05/04/typescript-in-emacs/
;;    https://github.com/ananthakumaran/tide
;;    https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04

(use-package tide
  :straight t)
(require 'tide)
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; tide format options (indent and tab to 2)
(setq tide-format-options '(:indentSize 2 :tabSize 2))

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook 'setup-tide-mode)

;; setup .tsx with web-mode
;; This block requires web-mode and flycheck

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

;; setup jsx with web-mode
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

(provide 'setup-typescript)
;;; setup-typescript.el ends here
