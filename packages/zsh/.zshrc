# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod g-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://z-shell.pages.dev/docs/gallery/collection
zicompinit # <- https://z-shell.pages.dev/docs/gallery/collection#minimal

# powerlevel10kのインストール
zi ice depth"1"
zi light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Oh My Zsh git
zi snippet OMZ::lib/git.zsh
zi snippet OMZ::plugins/git/git.plugin.zsh

# シンタックスハイライト
zi light zsh-users/zsh-syntax-highlighting

## 履歴補完
zi light zsh-users/zsh-autosuggestions

## コマンド補完
zi ice wait'!0'; zi light zsh-users/zsh-completions
autoload -Uz compinit && compinit

## Gitのレポシトリをブラウザで開く(git open)
zi ice wait'!0'; zi light paulirish/git-open

########## zi設定

# ⌃ r で peco で history 検索
function peco-history-selection() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-history-selection
bindkey '^r' peco-history-selection

## コマンド履歴からディレクトリ検索・移動 control + j で使用
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]* *//' | peco)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-cdr
bindkey '^O' peco-cdr

# 入力した文字から始まるコマンドを履歴から検索し、上下矢印で補完
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

## 履歴保存管理
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

## 他のzshと履歴を共有
setopt inc_append_history
setopt share_history

## パスを直接入力してもcdする
setopt AUTO_CD

## 環境変数を補完
setopt AUTO_PARAM_KEYS

## 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

## ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

## 補完時、大文字小文字を無視して補完し、大文字での補完の場合、見つからなかったときのみ小文字も表示する
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

## 履歴補完の色
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999,underline"

## alias
if builtin command -v bat > /dev/null; then
  alias cat="bat"
fi
alias ls="exa --icons"
alias gbdm="git-branch-delete-merged"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias flutter="fvm flutter"

# ローカルブランチをcheckout
gcop() {
  git branch --sort=-authordate |
    grep -v -e '->' -e '*' |
    perl -pe 's/^\h+//g' |
    perl -pe 's#^remotes/origin/##' |
    perl -nle 'print if !$c{$_}++' |
    peco |
    xargs git checkout
}
# マージ済みのgit branchを消去
PROTECT_BRANCHES='main|master|develop|development'
git-branch-delete-merged() {
    git branch --merged | egrep -v "\*|${PROTECT_BRANCHES}" | xargs git branch -d
}

## paths
# fnm
eval "$(fnm env --use-on-cd)"

# ruby rbenv
# eval "$(rbenv init - zsh)"

# fvm
export PATH="$PATH":"$HOME/fvm/default/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
