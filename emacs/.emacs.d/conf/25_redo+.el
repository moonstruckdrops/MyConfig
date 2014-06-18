;;====================
;; redo+ Settings
;;====================
(require 'redo+)
(global-set-key (kbd "") 'redo)
;; 過去のundoがredoされない設定
(setq undo-no-redo t)
;; 大量のundoに耐えられる設定
(setq undo-limit 600000)
(setq undo-strong-limit 900000)
