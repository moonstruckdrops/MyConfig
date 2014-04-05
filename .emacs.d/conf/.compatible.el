;;====================
;; Compatible
;;====================
;; Emacs 23より前のバージョンでuser-emacs-directory変数が未定義の為追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d")
  )
;; Emacs24より前のバージョンはパッケージ管理が存在しないので追加する
(when (< emacs-major-version 24)
  (load "~/.emacs.d/compatible/package-install.el")
  )
