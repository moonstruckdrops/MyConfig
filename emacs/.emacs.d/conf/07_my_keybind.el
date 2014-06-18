;;====================
;; Global KeyBind
;;====================
;; --------------------
;; Window環境用設定
;; --------------------
;; apps キー(カタカナ、ひらがな)を hyper キーにする
;; 右Windows キーを super キーにする
(when (eq window-system 'w32)
  (setq w32-apps-modifier 'hyper
        w32-rwindow-modifier 'super
        w32-lwindow-modifier 'super)
  )
;; super + → でウィンドウを左右に分割
(define-key global-map (kbd "s-<right>") 'split-window-horizontally)
;; super + ↓ でウィンドウを上下に分割
(define-key global-map (kbd "s-<down>") 'split-window-vertically)
;; super + w で現在のウィンドを削除
(define-key global-map (kbd "s-w") 'delete-window)
;; "C-t" でウィンドウを切り替える。初期値は transpose-chars
(define-key global-map (kbd "C-t") 'other-window)
;; 行の折り返し表示を切り替える
(define-key global-map (kbd "C-c l") 'toggle-trancate-lines)
;; 改行と同時にインデントを整形する
(define-key global-map (kbd "C-m") 'newline-and-indent)
;; 入力行にジャンプ
(define-key global-map (kbd "M-g") 'goto-line)
;;(global-set-key (kbd "M-g" 'goto-line))
