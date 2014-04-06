;;====================
;; Obsolute Android-mode Settings
;;====================
;; #android-mode.elの導入
(add-to-list `load-path "~/.emacs.d/android-mode/")
(require `android-mode)
(setq android-mode-sdk-dir "~/SDK/Android/android-sdk-mac_86")
;; #AndroidSDKに同梱されているandroid.elの導入
(add-to-list `load-path "~/SDK/Android/android-sdk-mac_86/tools/lib")
(require `android)
;; #Androidのデバイスへの共通コマンドを送信するandroid-host.elの導入
(require `android-host)
;; #Emacs内部でAndroidのソースコードをコンパイルするandroid-compile.elの導入
(require `android-compile)
(add-hook `c++-mode-hook `android-compile)
(add-hook `java-mode-hook `android-compile)
