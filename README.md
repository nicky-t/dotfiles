# dotfiles

## Macbook を新しくした際に、行うこと

1. キーボードとマウスパッドの速度変更
1. Finder の設定　https://tcd-theme.com/2020/11/mac-file-path.html
1. github と連携の設定を行い、git を扱える状態にする。
1. ホームディレクトリで以下のコマンドを実行し、dotfiles を clone する。

```
git clone https://github.com/nicky-t/dotfiles.git
```

5. dotfiles/shell の setup.sh を実行する。
1. シェルを brew によってインストールされた zsh に変更。

```
sudo vi /etc/shells
```

上記を実行し、ファイルを下記のように変更する。

```
/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
/opt/homebrew/bin/zsh # 追記しました　
```

chsh コマンドでログインシェルを切り替える。

```
chsh -s /opt/homebrew/bin/zs
```

ターミナルを再起動して、ログインシェルを確認する。

```
echo $SHELL
```

7 iterm2 の設定を同期する
https://ry-2718.hatenablog.com/entry/2019/04/02/021006

8 Xcode や Android studio などをダウンロードする

9 clean my mac の追加

10 nvim https://github.com/junegunn/vim-plug vimPlug のインストール

11 vim でノーマルモードに戻る際に英語に https://blog.pepo-le.com/vim-normalmode-imeoff/

12 fig の導入 https://fig.io/
