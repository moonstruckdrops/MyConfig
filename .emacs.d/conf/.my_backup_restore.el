;;====================
;; BackUp & Restore
;;====================
;; --------------------
;; 終了時にScratchバッファの保存再起動時に復元
;; --------------------
(defun save-scratch-data ()
  (let ((str (progn
               (set-buffer (get-buffer "*scratch*"))
               (buffer-substring-no-properties
                (point-min) (point-max))))
        (file "~/.emacs.d/backups/.scratch"))
    (if (get-file-buffer (expand-file-name file))
        (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert str)
    (save-buffer)
    (kill-buffer buf)))

(defadvice save-buffers-kill-emacs
  (before save-scratch-buffer activate)
  (save-scratch-data))

(defun read-scratch-data ()
  (let ((file "~/.emacs.d/backups/.scratch"))
    (when (file-exists-p file)
      (set-buffer (get-buffer "*scratch*"))
      (erase-buffer)
      (insert-file-contents file))
    ))

(read-scratch-data)

;; ------------------------------
;; ファイルバックアップ設定
;; ------------------------------
;; バックアップファイルの作成場所の設定
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
;; バックアップ世代数
(setq kept-old-versions 1)
(setq kept-new-versions 2)
;; オートセーブファイルの作成場所の設定
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))
;; オートセーブファイルの作成間隔を60秒にする
(setq auto-save-timeout 60)
;; オートセーブファイルのタイプ間隔を100にする
(setq auto-save-interval 100)
