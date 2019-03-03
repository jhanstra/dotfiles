#!/usr/bin/env node

const commander = require('commander')
const path = require('path')
const chalk = require('chalk')
const fs = require('fs')
const { exec } = require('child_process')

const home = require('os').homedir()
const dotfiles = path.join(__dirname, '..')

async function vscode() {
  console.log(chalk.blue('Linking VSCode settings to dotfiles'))
  await fs.unlink(`${home}/Library/Application Support/Code/User/settings.json`, () => {})
  await fs.symlink(`${dotfiles}/vscode/settings.json`, `${home}/Library/Application Support/Code/User/settings.json`, function() {})
  await fs.unlink(`${home}/Library/Application Support/Code/User/keybindings.json`, () => {})
  await fs.symlink(`${dotfiles}/vscode/keybindings.json`, `${home}/Library/Application Support/Code/User/keybindings.json`, function() {})
}

async function karabiner() {
  console.log(chalk.blue('Linking Karabiner settings to dotfiles'))
  await fs.unlink(`${home}/.config/karabiner/karabiner.json`, function() {})
  await fs.symlink(`${dotfiles}/karabiner/karabiner.json`, `${home}/.config/karabiner/karabiner.json`, function() {})
}

vscode()
karabiner()
