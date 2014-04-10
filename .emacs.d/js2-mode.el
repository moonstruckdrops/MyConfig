;; http://8-p.info/emacs-javascript.html
(require 'js2-mode)

(setq-default c-basic-offset 4)

(when (load "js2-mode" t)
  (setq js2-cleanup-whitespace nil
        js2-mirror-mode nil
        js2-bounce-indent-flag nil)
  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)
  (define-key js2-mode-map "\C-m" nil)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))
;; http://blog.ainam.me/2011/12/13/emacs-js2-mode-indent/
(add-hook 'js2-mode-hook
          '(lambda ()
             (require 'js)
             (setq js-indent-level 2
                    js-expr-indent-offset 2
                    indent-tabs-mode nil)
              (set (make-local-variable 'indent-line-function) 'js-indent-line)))
