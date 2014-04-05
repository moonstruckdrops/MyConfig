;; Ruby-mode
(when (require 'ruby-mode nil t)
  ;; インデントの幅を２
  (setq ruby-indent-level 2)
  ;; 改行時のインデントを調整する
  (setq ruby-deep-indent-paren-style nil)
  ;; タブ文字を使用する
  (setq ruby-indent-tabs-mode nil)
  ;; Ruby-modeで編集するファイルを設定
  (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode)))

;; ruby-electric
;; 括弧の自動挿入
(when (require 'ruby-electric nil t)
  (add-hook 'ruby-mode-hook
            (lambda ()
              (ruby-electric-mode t))))

;; ruby-block
;; endに対応する箇所のハイライト
;; 該当箇所をミニバッファに表示、かつオーバレイする
(when (require 'ruby-block nil t)
  (ruby-block-mode t)
  (setq ruby-block-highlight-toggle t))



;; Rsense
(setq rsense-home (expand-file-name "~/.emacs.d/elisp/rsense"))
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
;; C-c .で補完
;;(add-hook 'ruby-mode-hook
;;(lambda ()
;;  (local-set-key (kbd "C-c .") 'ac-complete-rsense)))
;;.や::を入力した直後に自動的に補完を開始したいなら、ac-sourcesにac-source-rsense-methodとac-source-rsense-contantを追加してください。
(add-hook 'ruby-mode-hook
         (lambda ()
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)
            (local-set-key (kbd "C-c .") 'ac-complete-rsense)))

;; auto-complete-ruby
;; rcodetoolsを使用する
(add-to-list 'load-path "/Users/moonstruckdrops/.rbenv/versions/1.9.3-p327/lib/ruby/gems/1.9.1/gems/rcodetools-0.8.5.0/")
;;(add-to-list 'load-path  "~/.rbenv/versions/2.0.0-p0/lib/ruby/gems/2.0.0/gems/rcodetools-0.8.5.0/")
;;(add-to-list 'load-path (expand-file-name "~/.rbenv/versions/2.0.0-p0/lib/ruby/gems/2.0.0/gems/rcodetools-0.8.5.0/"))
;;(add-to-list 'load-path "~/.rbenv/versions/2.0.0-p0/lib/ruby/gems/2.0.0/gems/rcodetools-0.8.5.0/")
;; http://www.cx4a.org/pub/auto-complete-ruby.el
(when (require 'auto-complete-ruby nil t)
  (setq ac-dwim nil)
  (set-face-background 'ac-selection-face "steelblue")
  (set-face-background 'ac-candidate-face "skyblue")
  (setq ac-auto-start t)
  (global-set-key "\M-/" 'ac-start)
  (setq ac-sources '(ac-source-abbrev ac-source-words-in-buffer))
  (add-hook 'ruby-mode-hook
            (lambda ()
              (require 'rcodetools)
              (require 'auto-complete-ruby)
              (make-local-variable 'ac-omni-completion-sources)
              (setq ac-omni-completion-sources '(("\\.\\=" . (ac-source-rcodetools)))))))
