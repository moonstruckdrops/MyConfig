;;====================
;; Global Settings
;;====================

;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)
;; C-kで行全体を削除
(setq kill-whole-line t)
;; TABの表示幅を4に設定する
(setq-default tab-width 2)
;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)

;; history から重複したのを消す
(require 'cl)
(defun minibuffer-delete-duplicate ()
 (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
     (unless (member elt list)
       (push elt list)))
    (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)



;; OSのクリップボードとkill-ringを同期する
(when (eq system-type  'gnu/linux)
  (when (window-system)
         (setq x-select-enable-clipboard t)))

;; 矩形選択のコマンドをを複雑にしないようにする
;; リージョン選択中に C-<enter> で矩形選択モード(矩形の貼付けは同じ)
(cua-mode t)
;; C-xが切り取りになるので無効化する
(setq cua-enable-cua-keys nil)
;;(global-set-key (kbd "C-w") 'cua-copy-rectangle)
