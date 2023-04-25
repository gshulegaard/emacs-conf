;;; package --- setup-c.el: Setup some basic c hooks

;;; Commentary:

;;; Code:

;;    Available C styles:
;;      “gnu”: The default style for GNU projects
;;      “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;;      “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;;      “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;;      “stroustrup”: What Stroustrup, the author of C++ used in his book
;;      “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;;      “linux”: What the Linux developers use for kernel development
;;      “python”: What Python developers use for extension modules
;;      “java”: The default style for java-mode (see below)
;;      “user”: When you want to define your own style

(setq c-default-style "linux")

;; when you press RET, the curly braces automatically
;; add another newline
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))

(provide 'setup-c)
;;; setup-c.el ends here
