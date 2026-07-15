# ========= Github specific settings ========= 
function gff {
	git merge --ff-only $1/$(current_branch)
}
alias gffo='gff origin'
alias gffu='gff upstream
alias gffi='gff imotov'

alias gfi='gf imotov'
alias gfu='gf upstream'
alias gfo='gf origin'

alias gpi='gp imotov "$(git_current_branch)"'
alias gpu='gp upstream "$(git_current_branch)"'
alias gpo='gp origin "$(git_current_branch)"'

alias gmiff='git merge --ff-only imotov/$(current_branch)'
alias gmuff='git merge --ff-only upstream/$(current_branch)'
alias gmoff='git merge --ff-only origin/$(current_branch)'

# fetch PR from remote 
function gprf {
  git fetch upstream pull/$1/head:pr/$1
}

# fetch PR and squash merge it into master
function gprm {
  gprf $1 && git merge --squash pr/$1
}

# clean after PR review
function gprc {
  git branch -D pr/$1 && git reset --hard HEAD
}

function gnow {
  GIT_COMMITTER_DATE=`date '+%Y-%m-%d %H:%M:%S %z'`
  git commit --amend  --no-edit --date "$GIT_COMMITTER_DATE"
}

function gda {
  git_date=$([[ $OS == "Darwin" ]] && date -v-$1d '+%Y-%m-%d %H:%M:%S %z' || date --date="$1 day ago" '+%Y-%m-%d %H:%M:%S %z')
  GIT_COMMITTER_DATE="$git_date" git commit --amend  --no-edit --date "$git_date"
}

# ========= Misc commands ========= 

function shuffle {
  for i; do
    echo $i
  done \
  | awk 'BEGIN{srand()}{print rand(), $0}' \
  | sort -n -k 1 \
  | awk 'sub(/^[0-9.]+ ([a-zA-Z0-9]+)$/,$2)' \
  | tr '\n' ' '
	echo
}

# Working directories
alias cds='cd ~/Software'
alias cdd='cd ~/Downloads'
alias cddf='cd ~/.dotfiles'
alias cdsb='cd ~/Sandbox'
alias cdp='cd ~/Projects'
alias cdpi='cd ~/Projects/imotov'
alias cdpn='cd ~/Projects/NVIDIA'
alias cdpe='cd ~/Projects/elastic'
alias cdpo='cd ~/Projects/opensearch-project'
