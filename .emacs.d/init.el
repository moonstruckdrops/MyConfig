;;====================
;; General
;;====================
;; サブディレクトリに配置したEmacs-Lispをload-pathを追加する関数を定義する
;; 以下の2行はEmacs 23より前のバージョンでuser-emacs-directory変数が未定義の為追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))
;; この関数を使用することで自動的にサブディレクトリもload-pathに追加するようになる
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list `load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 起動時のフレームサイズを設定する
(setq initial-frame-alist
      (append (list
        '(width . 177)
        '(height . 53)
        )
        initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)
;; C-kで行全体を削除
(setq kill-whole-line t)
;; *scratch*を消さないようにする
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))
(add-hook 'kill-buffer-query-functions
          ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (lambda ()
            (if (string= "*scratch*" (buffer-name))
                (progn (my-make-scratch 0) nil)
              t)))

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
;;(cond (window-system setq x-select-enable-clipboard t))
(set-frame-font "fontset-bitstreammarugo")
(set-fontset-font (frame-parameter nil 'font)
                   'unicode
                   (font-spec :family "Hiragino Maru Gothic ProN" :size 16)
                   nil
                   'append)

;; 矩形選択のコマンドをを複雑にしないようにする
;; リージョン選択中に C-<enter> で矩形選択モード(矩形の貼付けは同じ)
(cua-mode t)
;; C-xが切り取りになるので無効化する
(setq cua-enable-cua-keys nil)
;;(global-set-key (kbd "C-w") 'cua-copy-rectangle)

;; emacsclientを起動する
(require 'server)
(unless (server-running-p)
  (server-start))

;; emacsclientの終了をC-x kに変更する
(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
                (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")


;;====================
;; Language & Character encoding
;;====================
;; 言語を日本語にする
(set-language-environment 'Japanese)
;; ファイルの文字コードをUTF-8
(prefer-coding-system 'utf-8)
;; ファイル名の文字コードを設定する
;; Mac,Windows,Linuxでは取り扱いが異なる(Linuxはそのままでよいが,MacとWindowsは扱いが異なる為)
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
(when (eq window-system 'w32)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

;;(let* ((size 14)
;;         (asciifont "Menlo")
;;         (jpfont "Hiragino Maru Gothic ProN")
;;         (h (* size 10))
;;         (fontspec)
;;         (jp-fontspec))
;;    (set-face-attribute 'default nil :family asciifont :height h)
;;    (setq fontspec (font-spec :family asciifont))
;;    (setq jp-fontspec (font-spec :family jpfont))
;;    (set-fontset-font nil 'japanese-jisx0208 jp-fontspec)
;;    (set-fontset-font nil 'japanese-jisx0212 jp-fontspec)
;;    (set-fontset-font nil 'japanese-jisx0213-1 jp-fontspec)
;;    (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
;;    (set-fontset-font nil '(#x0080 . #x024F) fontspec)
;;    (set-fontset-font nil '(#x0370 . #x03FF) fontspec))


;;====================
;; Indent
;;====================
;; TABの表示幅を4に設定する
(setq-default tab-width 4)
;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)

;;====================
;; Files(use-mode)
;;====================

;;====================
;; Utilities(General)
;;====================
;; Emacs Lispが置いてあるpathを指定する
(add-to-load-path "elisp" "elpa" "conf" "auto-install")

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
  (setq auto-install-directory "~/.emacs.d/elisp")
  (auto-install-update-emacswiki-package-name t)
;;  (setq url-proxy `(("http" . "localhost:8080")))
  (auto-install-compatibility-setup)
  (setq ediff-window-setup-function `ediff-setup-windows-plain)
)

;; growl notifyの設定
;; 使用OSがMacでgrowlnotifyコマンドが存在する場合に実行可能にする
(setq growl-program "/usr/local/bin/growlnotify")
(defun growl (title message &optional app)
  (start-process "Growl" "*Growl*" growl-program
                 "-t" title
                 "-m" message
                 "-a" app))

;;====================
;; Utilities(auto-install)
;;====================
;; line-num
(require `linum)
;; デフォルトでlinum-modeを有効にする
(global-linum-mode t)
;; 5桁分の領域を確保して行番号の後にスペースを入れる
(setq linum-format "%5d ")

;;====================
;; Utilities(ELPA)
;;====================
;; ELPAを使用するpackage.elを読み込む
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

;;====================
;; Utilities(manual-install)
;;====================
(load ".my_visual")
(load ".my_keybind")
(load ".my_backup_restore")

;;(require 'navi2ch)
(load ".twitter")

(load ".ruby")
(load ".objective-c")

;; go-mode
(require 'go-mode)
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

;; anythingの導入
(require 'anything-startup)
;; C + ;でanythingを表示
(global-set-key (kbd "C-;") 'anything)
;; ファイルを開く
(global-set-key (kbd "C-x C-f") 'anything-find-files)
;; 貼付け時(yank)の場合、kill-ringの中身を表示してから実施
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;; anythingで対象とするkill-ringの要素を1文字からにする(デフォルトは10文字)
(setq anything-kill-ring-threshold 0)



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

;;====================
;; markdown
;;====================
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))

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


;; バッファ分割中にポップアップ
(require 'popup)
(require 'popup-select-window)
(global-set-key "\C-xo" 'popup-select-window)
;; 2つ以上のときにポップアップ
(setq popup-select-window-popup-windows 2)
;; 選択中のウィンドウの色を変更
(setq popup-select-window-window-highlight-face
      '(:foreground "white" :background "orange"))
