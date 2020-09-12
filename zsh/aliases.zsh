alias rl='. ~/.zshrc'
# alias x='exit'
alias cls='clear' # Good 'ol Clear Screen command
alias md='mkdir'
alias axiom="npx @coprime/axiom"
alias latest="npm i @coprime/concept@latest @coprime/codash@latest @coprime/next-config@latest && npm i -D @coprime/eslint-config@latest @coprime/rollup-config@latest @coprime/next-config@latest"
alias dot='code ~/coprime/dotfiles'
alias cdi='cd ~/indeed'
alias reload="source ~/.zshrc"
alias rl="source ~/.zshrc"
alias vcp="vc --prod"
alias prod="vc --prod"

# node
alias dev='npm run dev'
alias nd='npm run start:dev'
alias tst='npm run test'
alias start='npm run start'
alias build='npm run build'
alias lint="npm run lint"
alias testAll="npm run test:all"
alias deploy="now"
alias deps="npm install react react-dom next styled-components"
alias devDeps="npm install --save-dev @babel/core @babel/plugin-proposal-object-rest-spread @babel/preset-env babel-eslint babel-jest babel-loader babel-plugin-module-resolver babel-plugin-styled-components babel-register eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react prettier prettier-eslint"
alias npmGlobal='npm ls -g -depth=0'
alias bump='npm version patch --no-git-tag-version && npm publish'
alias id='npm i && dev'
alias bb='npm run build && bump'
alias link='npm run link-locally'
alias bump='npm run build && npm version patch --no-git-tag-version && npm publish'

# react
alias snap='jest --updateSnapshot'

# react native & xcode
alias rni="react-native run-ios"
alias rna="react-native run-android"
alias rnx="react-native run-ios --simulator \"iPhone X\""
alias rnif="rm -rf ios/build/; kill $(lsof -t -i:8081); react-native run-ios"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"




# Functions
## Why in the world did I have all those functions in the functions folder?
## This is so much simpler

dr() {
  deno run -A --unstable $1
}

drw() {
  denon run -A --unstable $1
}

dt() {
  deno test tests.ts --allow-read --allow-env --allow-write --unstable $1
}

dtw() {
  denon test -A --unstable tests.ts
}

e() {
  # finds the project you want to open with 'z', then opens it in your editor
  fasd_cd -d $1 && code .
}



di() {
  deno install
}

acp() {
  git add -A && git commit -m $1 && git push origin master
}

# i installs common sets of npm packages, e.g. all packages necessary for eslint, all packages necessary for a new Coprime project, etc
i() {
  if [ $1 = "eslint" ] || [ $2 = "eslint" ]
  then
    npm i -D @coprime/eslint-config@latest babel-eslint eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-import eslint-import-resolver-webpack eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react eslint-plugin-react-hooks prettier prettier-eslint eslint-plugin-mdx
  fi
  if [ $1 = "rollup" ] || [ $2 = "rollup" ]
  then
    npm i -D @coprime/rollup-config@latest @babel/core @babel/runtime @babel/plugin-proposal-object-rest-spread @babel/plugin-proposal-optional-chaining @babel/plugin-transform-runtime @babel/preset-env @babel/preset-react @babel/preset-typescript babel-plugin-module-resolver babel-plugin-styled-components rollup @rollup/plugin-node-resolve @rollup/plugin-commonjs @rollup/plugin-babel
  fi
  if [ $1 = "standard" ] || [ $2 = "standard" ]
  then
    npm i @coprime/concept@latest @coprime/codash@latest @coprime/api@latest @prisma/client @zeit/next-mdx next react react-dom react-hook-form styled-components dotenv swr
  fi
}


save() {
  git add -A && git commit -m $1
}

saveup() {
  git add -A && git commit -m $1 && git push origin
}

saveuppub() {
  git add -A && git commit -m $1 && git push origin && npm version patch && npm publish
}

bpatch() {
  npm run build && git add -A && git commit -m $1 && git push && npm version patch && npm publish
}



ports() {
  lsof -i tcp:$1
}

squash() {
  git rebase -i HEAD~$1
}

v() {
  if [ $# -eq 0 ]
  then
    vim .
  else
    fasd_cd -d $1 && vim .
  fi
}

gacp() {
  git add -A && git commit -m $1 && git push
}

gcp() {
  git commit -m $1 && git push origin master
}

gnb() {
  git checkout -b $1
}

gpo() {
  git push origin $1
}

minor() {
  git add -A && git commit -m $1 && git push && npm version minor && npm publish
}


patch() {
  npm run build && git add -A && git commit -m $1 && git push && npm version patch && npm publish
}
