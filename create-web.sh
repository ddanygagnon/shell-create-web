#!/bin/zsh

gitContent=$(cat ~/dev/.gitignore)
prettierContent=$(cat ~/dev/.prettierrc.json)
eslintContent=$(cat ~/dev/.eslintrc.js)
babelContent=$(cat ~/dev/.babelrc)
webpackContent=$(cat ~/dev/webpack.config.js)
htmlContent=$(cat ~/dev/index.html)
tsconfigContent=$(cat ~/dev/tsconfig.json)

mkdir "$1"
cd "$1" || exit
git init
echo "$1" > "readme.md"
echo "$gitContent" > ".gitignore"
git add --all
git commit -m "initial commit ✨"
yarn init -y

mkdir "src" "tests"
touch "src/index.ts" "tests/index.test.ts"

echo "Setup done"

# Commitizen
commitizen init cz-conventional-changelog --yarn --dev --exact
echo "Commitizen done"

# Husky
yarn add -D husky
npm set-script prepare "husky install"
npm run prepare
npx husky add .husky/pre-commit "yarn style && yarn lint && git add -A ."
echo "Husky done"

# Prettier
yarn add -D prettier
echo "$prettierContent" > ".prettierrc.json"
npm set-script style "prettier --write ."
echo "Prettier done"

# Typescript
yarn add -D typescript @types/node
echo "$tsconfigContent" > tsconfig.json
echo "Typescript done"

# Eslint
yarn add -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-google
npm set-script lint "eslint --ext .ts --fix src tests"
echo "$eslintContent" > ".eslintrc.js"
echo "Eslint done"

# Babel
yarn add -D @babel/core @babel/preset-env @babel/preset-typescript babel-loader
echo "$babelContent" > ".babelrc"
echo "Babel done"

# Webpack
yarn add -D webpack webpack-cli webpack-dev-server html-webpack-plugin
echo "$webpackContent" > "webpack.config.js"
mkdir "pages"
echo "$htmlContent" > "pages/index.html"
npm set-script dev "webpack serve"
npm set-script build "NODE_ENV=production webpack"
echo "Webpack done"

# Jest
yarn add -D jest ts-jest @types/jest
yarn ts-jest config:init
echo "Jest done"

# Standard version
yarn add standard-version -D
npm set-script release "standard-version"
echo "Standard version done"

git add --all
git commit -m "build(*): full build process from personal shell script"
