alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget -c'

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

if (( $+commands[eza] )); then
  alias eza="eza --group-directories-first --git";
  alias l="eza -blF";
  alias ll="eza -abghilmu";
  alias llm='ll --sort=modified'
  alias la="LC_COLLATE=C eza -ablF";
  alias tree='eza --tree'
fi

if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched

# kubernetes
export do="--dry-run=client -o yaml"
export now="--grace-period 0 --force"

# Other
alias virt-viewer='virt-viewer -c qemu:///system'

# ntfy
function ntfy() {
   local message="$*"
   local url="http://ntfy.server.com/other"
   curl -d "$message" -H "Priority: max" "$url"
}
