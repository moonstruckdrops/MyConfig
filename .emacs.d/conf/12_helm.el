;;====================
;; helm Settings
;;====================
(require 'helm-config)

;; ファイルを開く
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;; 貼付け時(yank)の場合、kill-ringの中身を表示してから実施
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

;; helmで対象とするkill-ringの要素を1文字からにする(デフォルトは3文字)
(setq helm-kill-ring-threshold 0)
