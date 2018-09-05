#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# Run Homebrew through the Brewfile
echo "› brew bundle"
brew bundle --file=BrewfilePersonal
