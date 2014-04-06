;;====================
;; auto-complete Settings
;;====================
;; 入力補完
(require 'auto-complete-config)
;; 補完を有効にする
(global-auto-complete-mode t)
;; 補完候補を保存した辞書
(add-to-list 'ac-dictionary-directories "~/.emacs.d/share//ac-dict")
;; デフォルト設定を有効
(ac-config-default)
;; 補完ウィンドウ内でのキー定義
(setq ac-use-menu-map t)
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "M-/") 'ac-stop)
;; 補完が自動で起動するのを停止
(setq ac-auto-start nil)
;; 起動キーの設定
(ac-set-trigger-key "TAB")
;; 候補の最大件数を20件に設定。 デフォルトは10件
(setq ac-candidate-max 20)

;; etags-table の機能を有効にする
(require 'etags-table)



;; objc-mode で補完候補を設定
;;(setq ac-modes (append ac-modes '(objc-mode)))
(setq ac-modes (append ac-modes '(java-mode)))

;; ac-source-etagsはauto-complete に etags の内容を認識させる変数
;; 3文字以上打たないと補完候補にならないように設定
;; requiresに設定した数字で補完候補を変更可
;;(setq tag-table-alist
;;		 '(("~/.emacs.d/" . "~/.emacs.d/share/frm.tags")))
(setq tag-table-alist
      '(("~/tmp/" . "~/tmp/java.tags")))
(setq etags-table-alist tag-table-alist)

(defvar ac-source-etags
  '((candidates . (lambda ()
                    (all-completions ac-target (tags-completion-table))))
    (candidate-face . ac-candidate-face)
    (selection-face . ac-selection-face)
    (requires . 3))
  "etags をソースにする")
;; objc で etags からの補完を可能にする
;;(add-hook 'objc-mode-hook
(add-hook 'java-mode-hook
          (lambda ()
            (push 'ac-source-etags ac-sources)))
