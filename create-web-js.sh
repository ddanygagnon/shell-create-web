#!/bin/zsh

gitContent=$(cat ~/dev/proj/.gitignore)
prettierContent=$(cat ~/dev/proj/.prettierrc.json)
eslintContent=$(cat ~/dev/proj/javascript/.eslintrc.js)
babelContent=$(cat ~/dev/proj/javascript/.babelrc)
webpackContent=$(cat ~/dev/proj/webpack.config.js)
htmlContent=$(cat ~/dev/proj/index.html)
mitContent=$(cat ~/dev/proj/MIT.txt)

mkdir "$1"
cd "$1" || exit
git init
echo "$1" > "readme.md"
echo "$gitContent" > ".gitignore"
git add --all
git commit -m "initial commit ✨"
yarn init -y

mkdir "src" "tests"
touch "src/index.js" "tests/index.test.js"

echo "Setup done"

# Devs
yarn add -D husky prettier @types/node eslint eslint-config-google @babel/core @babel/preset-env babel-loader webpack webpack-cli webpack-dev-server html-webpack-plugin jest @types/jest
# Commitizen
commitizen init cz-conventional-changelog --yarn --dev --exact
echo "Commitizen done"

# Husky
npm set-script prepare "husky install"
npm run prepare
npx husky add .husky/pre-commit "yarn style && yarn lint && git add -A ."
echo "Husky done"

# Prettier
echo "$prettierContent" > ".prettierrc.json"
npm set-script style "prettier --write ."
echo "Prettier done"

# Typescript
echo "$tsconfigContent" > tsconfig.json
echo "Typescript done"

# Eslint
npm set-script lint "eslint --ext .ts --fix src tests"
echo "$eslintContent" > ".eslintrc.js"
echo "Eslint done"

# Babel
echo "$babelContent" > ".babelrc"
echo "Babel done"

# Webpack
echo "$webpackContent" > "webpack.config.js"
mkdir "pages"
echo "$htmlContent" > "pages/index.html"
npm set-script dev "webpack serve"
npm set-script build "NODE_ENV=production webpack"
echo "Webpack done"

# Jest
yarn ts-jest config:init
echo "Jest done"

echo "$mitContent" > "LICENSE"

git add --all
git commit -m "build(*): full build process from personal shell script"
