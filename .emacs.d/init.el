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

(add-to-load-path "el-get" "elpa")

;;====================
;; Bootstrap::Initialize
;;====================
(require 'init-loader)
;; 設定ディレクトリ
(init-loader-load  (concat user-emacs-directory "conf"))
;; ログ表示
(setq init-loader-show-log-after-init t)


;;====================
;; Utilities(General)
;;====================

(load ".ruby")
(load ".objective-c")

;; go-mode
(load ".go")
;; json-mode
(require 'json)

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



;; #android-mode.elの導入
;;(add-to-list `load-path "~/.emacs.d/android-mode/")
;;(require `android-mode)
;;(setq android-mode-sdk-dir "~/SDK/Android/android-sdk-mac_86")
;; #AndroidSDKに同梱されているandroid.elの導入
;;(add-to-list `load-path "~/SDK/Android/android-sdk-mac_86/tools/lib")
;;(require `android)
;; #Androidのデバイスへの共通コマンドを送信するandroid-host.elの導入
;;(require `android-host)
;; #Emacs内部でAndroidのソースコードをコンパイルするandroid-compile.elの導入
;;(require `android-compile)
;;(add-hook `c++-mode-hook `android-compile)
;;(add-hook `java-mode-hook `android-compile)



;; growl notifyの設定
;; 使用OSがMacでgrowlnotifyコマンドが存在する場合に実行可能にする
(setq growl-program "/usr/local/bin/growlnotify")
(defun growl (title message &optional app)
  (start-process "Growl" "*Growl*" growl-program
                 "-t" title
                 "-m" message
                 "-a" app))


(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/opt/local/bin"
              "/sw/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))
