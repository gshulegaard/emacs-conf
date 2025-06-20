;;; package --- init.el: Emacs configuration entry point

;;; Commentary:

;;; Code:

;;   Add 'custom' folder to load path

(add-to-list 'load-path "~/.emacs.d/custom")

;; Bootstrap straight.el

(require 'straight-el)

;;   Setup packages

(require 'setup-packages)

;;   Setup basic customizations

(require 'settings)
;(require 'settings-term)

;;   X-graphics settings

(when (display-graphic-p) ; When using rich GUI
  (require 'settings-x))  ; X window settings

;;   IDE generics

(require 'setup-ide)

;;   Python

(require 'setup-python)

;;   Web

(require 'setup-web)

;;   C/C++

(require 'setup-c)

;;   Markdown

(require 'setup-markdown)

;;   TypeScript

(require 'setup-typescript)

;;   Rust

(require 'setup-rust)

;;   User extension file

(require 'user-setup)
;;; init.el ends here
