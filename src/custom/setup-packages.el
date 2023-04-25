;;; package --- setup-packages.el: Add external package archives.

;;; Commentary:

;;; Code:

;;   Install use-package

(straight-use-package 'use-package)
;(require 'use-package)

;;   Install el-patch

(use-package el-patch
  :straight t)

(provide 'setup-packages)
;;; setup-packages.el ends here
