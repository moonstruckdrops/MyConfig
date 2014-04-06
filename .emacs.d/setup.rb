# -*- coding: utf-8 -*-
require "shell"

# username : 引数1番目
# password : 引数2番目

##### Generate
conf_file_name = "conf/100_twitter_and_2ch.el"
twitter = <<EOS
(require 'navi2ch)
(require 'twittering-mode)
;; #認証方式、ユーザー名とパスワードの設定
(setq twittering-auth-method 'xauth)
(setq twittering-username "#{ARGV[0]}")
(setq twittering-password "#{ARGV[1]}")
;; #プロキシ設定
;; (setq twittering-proxy-use ユーザー名)
;; (setq twittering-proxy-server "127.0.0.1")
;; (setq twittering-proxy-port 8080)
;; フォーマット設定
(setq twittering-status-format "%i %s ( %S ) , %@ \\n\\n  %t \\n\\n from %f%L\\n\\n")
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
EOS
open(conf_file_name, "w") {|f|
   f.write twitter
}
