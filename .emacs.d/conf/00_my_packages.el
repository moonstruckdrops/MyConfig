;;==============================
;;
;; package
;;
;;==============================
(require 'package)

;; インストール先の一覧
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; インストールするpackage一覧
(defvar my-package-list
  '(helm
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
    twittering-mode
    yaml-mode
    yasnippet)
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
