;;====================
;; EmacsClient Settings
;;====================

;; 起動時にemacsclientを起動する
(require 'server)
(unless (server-running-p)
  (server-start))

;; emacsclientの終了をC-x kに変更する
(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
                (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))
