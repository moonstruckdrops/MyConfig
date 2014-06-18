;;====================
;; Obsolute Anything Settings
;;====================

;; anythingの導入
(require 'anything-startup)
;; C + ;でanythingを表示
(global-set-key (kbd "C-;") 'anything)
;; ファイルを開く
(global-set-key (kbd "C-x C-f") 'anything-find-files)
;; 貼付け時(yank)の場合、kill-ringの中身を表示してから実施
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;; anythingで対象とするkill-ringの要素を1文字からにする(デフォルトは10文字)
(setq anything-kill-ring-threshold 0)
