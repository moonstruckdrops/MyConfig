# -*- coding: utf-8 -*-
require "shell"

##### Directory
dir_list = {
   :elisp_dir=>"elisp",
   :backups_dir=>"backups",
   :elpa_dir=>"elpa",
   :share_dir=>"share",
   :url_dir=>"url",
}

##### execute
result_dir = []
sh = Shell.new
dir_list.each{|key,value|
#   result_dir = sh.mkdir(value)
}



##### Generate
conf_file_name = "conf/.twitter.el"
twitter = <<EOS
(require `twittering-mode)
;; #認証方式、ユーザー名とパスワードの設定
(setq twittering-auth-method 'xauth)
(setq twittering-username "username")
(setq twittering-password "password")
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



##### Notification
p "##################"
p "Lisp Directory Success!!"
result_dir.each{|result|
   p result
}

p "Please install elisp."
package= <<-EOS
    twittering-mode
    ruby-electric
    ruby-end
    ruby-mode
    ruby-block
    markdown-mode
    json
    gtags
    groovy-mode
    flymake-ruby
    flymake-easy
    company
    go
    popup
    anything
    linum
EOS
p package
p "##################"

