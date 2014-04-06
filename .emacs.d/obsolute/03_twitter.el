;;====================
;; Obsolute Twitter Settings
;;====================
;; Growl notifyによる通知(replayとDMを通知するように設定)
(add-hook 'twittering-new-tweets-hook
          '(lambda ()
             (let ((spec (car twittering-new-tweets-spec))
                   (title-format nil))
               (cond ((eq spec 'replies)
                      (setq title-format "%sから関連ツイート"))
                     ((eq spec 'direct_messages)
                      (setq title-format "%sから新規メッセージ"))
                     ((eq spec 'home)
                      (setq title-format "%sの新規ツイート"))
                     )
               (unless (eq title-format nil)
                 (dolist (el (reverse twittering-new-tweets-statuses))
                   (growl (format title-format (cdr (assoc 'user-screen-name el)))
                          (format "%s" (cdr (assoc 'text el)))
                          "Emacs")
                   (sleep-for 0 50))))))
