;;====================
;; popup-select-window Settings
;;====================
;; バッファ分割中にポップアップ
(require 'popup)
(require 'popup-select-window)
(global-set-key "\C-xo" 'popup-select-window)
;; 2つ以上のときにポップアップ
(setq popup-select-window-popup-windows 2)
;; 選択中のウィンドウの色を変更
(setq popup-select-window-window-highlight-face
      '(:foreground "white" :background "orange"))
