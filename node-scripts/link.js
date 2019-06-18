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
  await fs.symlink(`${dotfiles}/vscode/settings.json`, `${home}/Library/Application Support/Code/User/settings.json`, () => {})
  await fs.symlink(`${dotfiles}/vscode/keybindings.json`, `${home}/Library/Application Support/Code/User/keybindings.json`, () => {})
}

async function karabiner() {
  console.log(chalk.blue('Linking Karabiner settings to dotfiles'))
  await fs.unlink(`${home}/.config/karabiner/karabiner.json`, () => {})
  await fs.symlink(`${dotfiles}/karabiner/karabiner.json`, `${home}/.config/karabiner/karabiner.json`, () => {})
}

async function hammerspoon() {
  console.log(chalk.blue('Linking Hammerspoon settings to dotfiles'))
  await fs.symlink(`${dotfiles}/hammerspoon`, `${home}/.hammerspoon`, () => {})
}

vscode()
karabiner()
hammerspoon()
