;;====================
;; Visual
;;
;; 色見本のページ
;; http://homepage1.nifty.com/blankspace/emacs/emacs_rgb.html
;; http://life.a.la9.jp/hp/color/index.html
;;====================
;; ----------------------
;; バッファ画面の装飾設定
;; ----------------------
;; Emacsのシステムを変更する
(if window-system (progn
  ;; 文字色を変更
  (add-to-list `default-frame-alist '(foreground-color ."green"))
  ;; 背景色を変更
  (add-to-list `default-frame-alist '(background-color ."black"))
  ))

;; タブ, 全角スペース, 行末空白表示
;; 全角スペース
(defface my-face-b-1 '((t (:background "PowderBlue"))) nil)
;; タブ
(defface my-face-b-2 '((t (:background "LightBlue"))) nil)
;; 行末空白
(defface my-face-u-1 '((t (:background "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; ----------------------
;; カーソル行の装飾設定
;; ----------------------
;; 対応するカッコをハイライト
(show-paren-mode 1)
;; 現在行のハイライト
;; 現在の行に下線を表示する
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "dark slate gray"
                  :underline "DarkOrange2"))
    (((class color) (background light))
     (:background "ForestGreen"
                  :underline "DarkOrange2"))
    (t(:bold t)))
  "*Face used by hl-line.")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)
;; mini bufferの文字色を変更する
(set-face-foreground 'minibuffer-prompt "green")

;; ----------------------
;; フレームの装飾設定
;; ----------------------
;; スクロールバーを非表示
(scroll-bar-mode 0)
;; スタートページ非表示
(setq inhibit-startup-message t)
;; カーソル位置の行を強調
(global-hl-line-mode t)
;; 画面の透過度を設定(0から100までの数値を指定)
(set-frame-parameter nil 'alpha 100)

;; ---------------------
;; モードラインの設定
;; ---------------------
;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")
;; カラム番号を表示
(column-number-mode t)
;; ファイルサイズを表示
(size-indication-mode t)


;; ---------------------
;; 行番号の設定
;; ---------------------
(require `linum)
;; デフォルトでlinum-modeを有効にする
(global-linum-mode t)
;; 5桁分の領域を確保して行番号の後にスペースを入れる
(setq linum-format "%5d ")
