;;==============================
;;
;; package
;;
;;==============================
(require 'cl)

;; --------------------
;; packages.el経由
;; --------------------
(require 'package)
;; インストール先の一覧
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; インストールするpackage一覧
(defvar my-package-list
  '(exec-path-from-shell
    cl-lib
    auto-complete
    helm
    helm-ag
    android-mode
    company
    etags-table
    findr
    flymake-easy
    flymake-ruby
    go-mode
    groovy-mode
    gtags
    hlinum
    inf-ruby
    inflections
    init-loader
    json
    jump
    markdown-mode
    popup
    redo+
    rinari
    rsense
    ruby-block
    ruby-compilation
    ruby-electric
    ruby-end
    ruby-mode
    php-mode
    twittering-mode
    yaml-mode
    yasnippet
    navi2ch)
  )

;; Emacs起動時に自動でパッケージをインストール
(let ((not-installed
       (loop for x in my-package-list
             when (not (package-installed-p x))
             collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))


;; --------------------
;; el-get経由
;; --------------------
;; el-getが存在しない場合にel-getを追加する
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; el-getのrecipeとインストール先の設定をする
(require 'el-get)
(setq el-get-dir (expand-file-name (concat user-emacs-directory "el-get/packages")))
(add-to-list 'el-get-recipe-path (concat user-emacs-directory "el-get/recipes"))

(defvar my-el-get-packages
  '(popup-select-window
    ac-company
    ipa
    ))

(el-get 'sync my-el-get-packages)
