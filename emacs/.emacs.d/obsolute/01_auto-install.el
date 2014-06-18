;;====================
;; auto-install Settings
;;====================
;; auto-installの設定
;; wgetコマンドが見つかった場合は以下の設定を実行する
;; 1.auto-installのpathを設定
;; 2.起動時にEmacsWikiを補完候補に加える
;; 3.install-elisp.el互換モードにする
;; 4.ediff関連のバッファを一つのフレームにまとめる
;; このauto-installを利用するには以下を設定しておく
;; 1.wgetコマンドをインストールし利用可能にする
;; 2.シンボリックリンクを作成しておく
;;   sudo ln -s /opt/local/bin/wget /usr/bin/wget
(when (executable-find "wget")
  (require `auto-install)
  (setq auto-install-directory
        (expand-file-name (concat user-emacs-directory "elisp")))
  (auto-install-update-emacswiki-package-name t)
  ;;  (setq url-proxy `(("http" . "localhost:8080")))
  (auto-install-compatibility-setup)
  (setq ediff-window-setup-function `ediff-setup-windows-plain)
)
