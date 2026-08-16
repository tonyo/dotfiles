#!/usr/bin/env bash
# Status line for Claude Code.
# To enable it, move this script to ~/.claude/statusline-command.sh, and add
# the following to ~/.claude/settings.json:
#
# {
#   ...
#   "statusLine": {
#     "type": "command",
#     "command": "bash \"$HOME/.claude/statusline-command.sh\""
#   },
#   ...
# }
input=$(cat)

{ read -r MODEL; read -r DIR; read -r COST; read -r PCT; read -r DURATION_MS; } <<< "$(echo "$input" | jq -r '
  .model.display_name,
  .workspace.current_dir,
  (.cost.total_cost_usd // 0),
  (.context_window.used_percentage // 0 | floor),
  (.cost.total_duration_ms // 0)
')"

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; BLUE='\033[34m'; RESET='\033[0m'

if   [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else                          BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10))
printf -v FILL "%${FILLED}s"; printf -v PAD "%$((10 - FILLED))s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH="" AHEAD_BEHIND="" DIFF_STATS=""
GIT_STATUS=$(git -C "$DIR" status --porcelain=v2 --branch 2>/dev/null)
if [ $? -eq 0 ]; then
  BRANCH_NAME="" HAS_TRACKING="" AHEAD=0 BEHIND=0 HAS_STAGED="" HAS_UNSTAGED=""
  while IFS= read -r line; do
    if   [[ "$line" == "# branch.head "* ]];     then BRANCH_NAME="${line#'# branch.head '}"
    elif [[ "$line" == "# branch.upstream "* ]]; then HAS_TRACKING=1
    elif [[ "$line" == "# branch.ab "* ]]; then
      ab="${line#'# branch.ab '}"; AHEAD="${ab%% *}"; AHEAD="${AHEAD#+}"
      BEHIND="${ab##* }"; BEHIND="${BEHIND#-}"
    elif [[ "$line" =~ ^[12]\ (..) ]]; then
      [[ "${BASH_REMATCH[1]:0:1}" != "." ]] && HAS_STAGED=1
      [[ "${BASH_REMATCH[1]:1:1}" != "." ]] && HAS_UNSTAGED=1
    fi
  done <<< "$GIT_STATUS"

  BRANCH="🌿 ${BRANCH_NAME}"

  if   [ -n "$HAS_UNSTAGED" ] && [ -n "$HAS_STAGED" ]; then CHANGE_FLAG="*+ "
  elif [ -n "$HAS_UNSTAGED" ]; then CHANGE_FLAG="* "
  elif [ -n "$HAS_STAGED" ];   then CHANGE_FLAG="+ "
  else                               CHANGE_FLAG=""
  fi

  if [ -n "$HAS_TRACKING" ]; then
    if   [ "$AHEAD" -gt 0 ] && [ "$BEHIND" -gt 0 ]; then UPSTREAM_STATUS="${GREEN}+${AHEAD}${RESET}${RED}-${BEHIND}${RESET}"
    elif [ "$AHEAD" -gt 0 ];  then UPSTREAM_STATUS="${GREEN}+${AHEAD}${RESET}"
    elif [ "$BEHIND" -gt 0 ]; then UPSTREAM_STATUS="${RED}-${BEHIND}${RESET}"
    else                           UPSTREAM_STATUS="${BLUE}=${RESET}"
    fi
    AHEAD_BEHIND=" (${CHANGE_FLAG}u${UPSTREAM_STATUS})"
  elif [ -n "$CHANGE_FLAG" ]; then
    AHEAD_BEHIND=" (${CHANGE_FLAG% })"
  fi

  read -r DIFF_ADD DIFF_DEL <<< "$(git -C "$DIR" diff HEAD --numstat 2>/dev/null | awk '{add+=$1; del+=$2} END {print add+0, del+0}')"
  if [ "$DIFF_ADD" -gt 0 ] || [ "$DIFF_DEL" -gt 0 ]; then
    DIFF_STATS=" ${GREEN}+${DIFF_ADD}${RESET}/${RED}-${DIFF_DEL}${RESET}"
  fi
fi

COST_FMT=$(printf '$%.2f' "$COST")
echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/} | ${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET}"
echo -e "${BRANCH}${AHEAD_BEHIND}${DIFF_STATS} | ⏱️  ${MINS}m ${SECS}s"
