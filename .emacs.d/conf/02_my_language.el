;;====================
;; Language & Character encoding Setting
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

;;(set-frame-font "fontset-bitstreammarugo")
;;(set-fontset-font (frame-parameter nil 'font)
;;                   'unicode
;;                   (font-spec :family "Hiragino Maru Gothic ProN" :size 16)
;;                   nil
;;                   'append)

(let* ((size 14)
         (asciifont "Menlo")
         (jpfont "Hiragino Maru Gothic ProN")
         (h (* size 10))
         (fontspec)
         (jp-fontspec))
    (set-face-attribute 'default nil :family asciifont :height h)
    (setq fontspec (font-spec :family asciifont))
    (setq jp-fontspec (font-spec :family jpfont))
    (set-fontset-font nil 'japanese-jisx0208 jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0212 jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0213-1 jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
    (set-fontset-font nil '(#x0080 . #x024F) fontspec)
    (set-fontset-font nil '(#x0370 . #x03FF) fontspec))
