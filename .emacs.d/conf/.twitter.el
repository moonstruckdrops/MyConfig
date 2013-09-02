(require `twittering-mode)
;; #認証方式、ユーザー名とパスワードの設定
(setq twittering-auth-method 'xauth)
(setq twittering-username "774san")
(setq twittering-password "geforcego")
;; #プロキシ設定
;; (setq twittering-proxy-use ユーザー名)
;; (setq twittering-proxy-server "127.0.0.1")
;; (setq twittering-proxy-port 8080)
;; フォーマット設定
(setq twittering-status-format "%i %s ( %S ) , %@ \n\n  %t \n\n from %f%L\n\n")
;; アイコン表示
(setq twittering-icon-mode t)
;; 更新間隔設定(120秒に設定している)
(setq twittering-timer-interval 120)
;; 短縮URL設定
(setq twittering-tinyurl-service 'goo.gl)
;; キーバインド変更
(add-hook 'twittering-mode-hook
           (lambda ()
             (mapc (lambda (pair)
                     (let ((key (car pair))
                           (func (cdr pair)))
                       (define-key twittering-mode-map
                         (read-kbd-macro key) func)))
                   '(("C-c f" . twittering-favorite)))))

;; Growl notifyによる通知(replayとDMを通知するように設定)    
(add-hook 'twittering-new-tweets-hook
	  '(lambda ()
	     (let ((spec (car twittering-new-tweets-spec))
		   (title-format nil))
	       (cond ((eq spec 'replies)
		      (setq title-format "%sから関連ツイート"))
		     ((eq spec 'direct_messages)
		      (setq title-format "%sから新規メッセージ"))
;;    	     ((eq spec 'home)
;;    	      (setq title-format "%sの新規ツイート"))
             )
	       (unless (eq title-format nil)
		 (dolist (el (reverse twittering-new-tweets-statuses))
		   (growl (format title-format (cdr (assoc 'user-screen-name el)))
			  (format "%s" (cdr (assoc 'text el)))
			  "Emacs")
		   (sleep-for 0 50))))))
