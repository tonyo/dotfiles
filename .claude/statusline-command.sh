#!/usr/bin/env bash
# Status line for Claude Code.
# To enable it, move this script to ~/.claude/statusline-command.sh, and add
# the following to ~/.claude/settings.json:
#
# {
#   ...
#   "statusLine": {
#     "type": "command",
#     "command": "bash /home/tonyo/.claude/statusline-command.sh"
#   },
#   ...
# }

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_add=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_del=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH=""
GIT_COUNTS=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=" | 🌿 $(git -C "$DIR" branch --show-current 2>/dev/null)"
  STAGED=$(git -C "$DIR" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  VELOCITY="${GREEN}+${lines_add}${RESET} ${RED}-${lines_del}${RESET}"
fi

COST_FMT=$(printf '$%.2f' "$COST")
echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}${BRANCH}"
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱️  ${MINS}m ${SECS}s | ${VELOCITY}"
