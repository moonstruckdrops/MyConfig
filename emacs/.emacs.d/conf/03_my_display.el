;;====================
;; Display Setting
;;====================

;; Mac専用に画面解像度に応じてフレームサイズを動的に設定
;; 文字幅に応じてフレームサイズを決定しているので、
;; 下記の内容に注意
;; * 文字の設定を先にロードすること
;; * 装飾やminibuffer分減算していること
(when (eq system-type 'darwin)
  (when (window-system)
    (set-frame-size (selected-frame)
                    (floor (- (/ (x-display-pixel-width) (frame-char-width)) 3))
                    (floor (- (/ (x-display-pixel-height) (frame-char-height)) 3)))))


;; Linux Settings
(when (eq system-type 'gnu/linux)
  (setq initial-frame-alist
        (append (list
                 '(width . 55)
                 '(height .57)
                 )
                initial-frame-alist))
  (setq default-frame-alist initial-frame-alist))
