;;; package --- settings-term.el: Customization for shell colors in emacs

;;; Commentary:

;;   You can use terminal instead of the inferior Emacs "shell" mode by typing
;;   "M-X term" or "M-X ansi-term" (the latter has full ANSI support).
;;
;;   Because term/ansi-term modes are terminal emulators, Emacs will not do
;;   input pre-processing by default (Emacs shortcuts will not work, instead
;;   they are sent straight to the emulator).  You can switch modes using
;;   "C-c C-j" (line mode) and "C-c C-k" (char mode).  Line mode captures Emacs
;;   key bindings and char mode sends them straight to the emulator.

;;; Code:

;;    Color your shell text

;;    Set the color face aliases (these are set to "Zenburn" colors)
;;    http://stackoverflow.com/questions/15661372/adjusting-term-faces-in-the-new-emacs-24-3

(defface term-color-black
  '((t (:foreground "#3f3f3f" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-red
  '((t (:foreground "#cc9393" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-green
  '((t (:foreground "#7f9f7f" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-yellow
  '((t (:foreground "#f0dfaf" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-blue
  '((t (:foreground "#6d85ba" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-magenta
  '((t (:foreground "#dc8cc3" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-cyan
  '((t (:foreground "#93e0e3" :background "#272822")))
  "Unhelpful docstring.")
(defface term-color-white
  '((t (:foreground "#dcdccc" :background "#272822")))
  "Unhelpful docstring.")
'(term-default-fg-color ((t (:inherit term-color-white))))
'(term-default-bg-color ((t (:inherit term-color-black))))

;; ansi-term colors
(setq ansi-term-color-vector
  [term term-color-black term-color-red term-color-green term-color-yellow
    term-color-blue term-color-magenta term-color-cyan term-color-white])

(provide 'settings-term)
