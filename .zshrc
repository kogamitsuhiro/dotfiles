: "一般的な設定" && {
  autoload -U compinit && compinit -d ${COMPDUMPFILE} # 補完機能の強化
  setopt correct # 入力しているコマンド名が間違っている場合にもしかして：を出す。
  setopt nobeep # ビープを鳴らさない
  setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる。
  setopt auto_menu # タブによるファイルの順番切り替えをする
  setopt auto_pushd # cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
  setopt auto_cd # ディレクトリ名を入力するだけでcdできるようにする
  setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' #大文字、小文字を区別せず補完する
  zstyle ':completion:*:default' menu select=1 #カーソルで補間候補を選ぶ
}

: "ヒストリ関連の設定" && {
  export HISTFILE=${HOME}/.zsh_history
  HISTSIZE=10000 # メモリに保存される履歴の件数
  SAVEHIST=10000 # 履歴ファイルに保存される履歴の件数
  setopt hist_ignore_dups # 直前と同じコマンドをヒストリに追加しない
  setopt hist_ignore_all_dups # 重複するコマンドは古い法を削除する
  setopt share_history # 異なるウィンドウでコマンドヒストリを共有する
  setopt hist_no_store # historyコマンドは履歴に登録しない
  setopt hist_verify # `!!`を実行したときにいきなり実行せずコマンドを見せる
  setopt HIST_EXPAND # 補完時にヒストリを自動的に展開する

  autoload history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end

  bindkey '^P' history-beginning-search-backward-end
  bindkey '^N' history-beginning-search-forward-end
  bindkey '^[[A' history-beginning-search-backward-end # ↑キー
  bindkey '^[[B' history-beginning-search-forward-end  # ↓キー
}

: "エイリアス設定" && {
    alias ls='ls -G' # 色分け表示する
    alias la='ls -aG' # 全てのファイルを表示する
    alias ll='ls -lG' # 詳細まで表示する
    alias rm='rm -i' # 削除する時に確認する
    alias mv='mv -i' # mvする対象が既に存在していたら確認する
    alias cp='cp -i' # cpする対象がすでに存在していたら確認する
    alias ..='cd ..' # 親のディレクトリに移動する
    alias g='git'
    alias gb='git branch'
    alias gco='git checkout'
    alias gst='git status'
    alias ga='git add'
    alias gd='git diff --histogram'
    alias gc='git commit'
    alias gr="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"
}


: "cd先のディレクトリのファイル一覧を表示する" && {
  [ -z "$ENHANCD_ROOT" ] && function chpwd { tree -L 1 } # enhancdがない場合
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
  [ -z "$ENHANCD_ROOT" ] || export ENHANCD_HOOK_AFTER_CD="tree -L 1" # enhancdがあるときはそのHook機構を使う
}

: "プロンプト表示設定" && {
  # プロンプト左側
  PROMPT='%F{245}%~%f
%B%F{213}❯❯❯%f%b '

  # プロンプト右側
  RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
  autoload -Uz vcs_info
  setopt prompt_subst
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
  zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
  zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
  zstyle ':vcs_info:*' actionformats '[%b|%a]'
  precmd () { vcs_info }
  RPROMPT=$RPROMPT'${vcs_info_msg_0_}'
}
