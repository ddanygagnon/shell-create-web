module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: ['google'],
  parserOptions: {
    ecmaVersion: 12,
    sourceType: 'module',
  },
  rules: {
    'require-jsdoc': 'warn',
    'no-unused-vars': 'warn',
  },
};
