;;====================
;; shell-mode Settings
;;====================
;; エスケープシーケンスによる色がつくようにする
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; パスワード入力の際にパスワードを*に置換
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
