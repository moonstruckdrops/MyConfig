;;====================
;; Compatible
;;====================
;; Emacs 23より前のバージョンでuser-emacs-directory変数が未定義の為追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))
;; Emacs24より前のバージョンはパッケージ管理が存在しないので追加する
(when (< emacs-major-version 24)
  (load (expand-file-name (concat user-emacs-directory "compatible/package-install.el"))))

;;====================
;; Bootstrap::load-path
;;====================
;; サブディレクトリに配置したEmacs-Lispをload-pathを追加する関数を定義する
;; この関数を使用することで自動的にサブディレクトリもload-pathに追加するようになる
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list `load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "manager" "el-get" "elpa")

;;====================
;; Bootstrap::Initialize
;;====================
;; タイトルにフルパスを表示
(setq frame-title-format "%f")
;; ツールバーを非表示
(tool-bar-mode 0)
;; メニューバーを非表示
(menu-bar-mode 0)

;; 使用パッケージのインストール
(load "my_packages")

(require 'init-loader)
;; 設定ディレクトリ
(init-loader-load  (concat user-emacs-directory "conf"))
;; ログ表示
(setq init-loader-show-log-after-init t)
