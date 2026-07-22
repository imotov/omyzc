# ========= Self-update (mirrors Oh-My-Zsh's own update check) =========
#
# Periodically checks origin for new commits and either reminds you or
# auto-updates, rate-limited by a timestamp file so it doesn't slow down
# every new shell.
#
# Configure in ~/.zshrc (before this is sourced), e.g.:
#   zstyle ':omyzc:update' mode auto     # auto | reminder (default) | disabled
#   zstyle ':omyzc:update' frequency 7   # days between checks (default: 7)

OMYZC_UPDATE_STAMP="$ZSH_CUSTOM/.zsh-update"

function _omyzc_update_mode {
  local mode
  zstyle -s ':omyzc:update' mode mode || mode=reminder
  echo "$mode"
}

function _omyzc_update_frequency_days {
  local freq
  zstyle -s ':omyzc:update' frequency freq || freq=7
  echo "$freq"
}

function _omyzc_update_due {
  local last now freq_secs
  now=$(date +%s)
  freq_secs=$(( $(_omyzc_update_frequency_days) * 86400 ))
  last=0
  if [[ -f "$OMYZC_UPDATE_STAMP" ]]; then
    last=$(cat "$OMYZC_UPDATE_STAMP" 2>/dev/null)
    [[ "$last" =~ ^[0-9]+$ ]] || last=0
  fi
  (( now - last >= freq_secs ))
}

function _omyzc_update_touch_stamp {
  date +%s > "$OMYZC_UPDATE_STAMP"
}

# Fetch origin and fast-forward if behind. With --check-only, just reports
# whether an update is available without pulling.
function omyzc_update {
  (
    cd "$ZSH_CUSTOM" || return 1
    git rev-parse --is-inside-work-tree &>/dev/null || {
      echo "omyzc: $ZSH_CUSTOM is not a git repo, skipping update" >&2
      return 1
    }

    local before after branch upstream
    before=$(git rev-parse HEAD 2>/dev/null)
    GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o ConnectTimeout=5 -o BatchMode=yes" \
      git -c http.lowSpeedLimit=1 -c http.lowSpeedTime=5 fetch --quiet origin || {
      echo "omyzc: update check failed (network?)" >&2
      return 1
    }

    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    upstream="origin/${branch:-main}"
    after=$(git rev-parse "$upstream" 2>/dev/null)

    if [[ -z "$after" || "$before" == "$after" ]]; then
      [[ "$1" == "--check-only" ]] || echo "omyzc: already up to date."
      return 1
    fi

    if [[ "$1" == "--check-only" ]]; then
      echo "omyzc: update available ($before -> $after). Run 'omyzc_update' to pull."
      return 0
    fi

    if git merge-base --is-ancestor "$before" "$after" 2>/dev/null; then
      git merge --ff-only --quiet "$upstream"
      echo "omyzc: updated $before -> $after. Restart your shell (or 'exec zsh') to load changes."
    else
      echo "omyzc: local branch has diverged from $upstream, skipping auto-merge. Resolve manually in $ZSH_CUSTOM." >&2
      return 1
    fi
  )
}
alias omyzcup='omyzc_update'

function _omyzc_update_check {
  [[ -n "$ZSH_CUSTOM" && -d "$ZSH_CUSTOM/.git" ]] || return
  local mode=$(_omyzc_update_mode)
  [[ "$mode" == "disabled" ]] && return
  _omyzc_update_due || return

  _omyzc_update_touch_stamp

  if [[ "$mode" == "auto" ]]; then
    omyzc_update
  else
    omyzc_update --check-only
  fi
}

_omyzc_update_check
