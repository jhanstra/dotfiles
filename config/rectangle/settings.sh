#!/usr/bin/env bash
# Stable Rectangle preferences; transient update/version state is omitted

set -euo pipefail

DOMAIN="com.knollsoft.Rectangle"

defaults write "$DOMAIN" alternateDefaultShortcuts -bool true
defaults write "$DOMAIN" gapSize -int 20
defaults write "$DOMAIN" hideMenubarIcon -bool true
defaults write "$DOMAIN" launchOnLogin -bool true
defaults write "$DOMAIN" subsequentExecutionMode -int 1
defaults write "$DOMAIN" centerHalf -dict keyCode 8 modifierFlags 1835008
defaults write "$DOMAIN" maximize -dict keyCode 3 modifierFlags 786432
defaults write "$DOMAIN" reflowTodo -dict keyCode 45 modifierFlags 786432
defaults write "$DOMAIN" landscapeSnapAreas -string \
  '[3,{"action":16},8,{"action":14},5,{"compound":-3},6,{"action":13},1,{"action":15},7,{"compound":-4},4,{"compound":-2},2,{"action":2}]'
