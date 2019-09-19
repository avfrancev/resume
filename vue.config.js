const path = require('path')
const fs = require('fs')

module.exports = {
  // lintOnSave: false,
  // productionSourceMap: false,
  chainWebpack: config => {
    const types = ['vue-modules', 'vue', 'normal-modules', 'normal']
    types.forEach(type => addStyleResource(config.module.rule('stylus').oneOf(type)))
    config.entry('app')
      .clear()
      .add('./src/main.coffee')
      .end()
    config.module
      .rule('coffee')
      .test(/\.coffee$/)
      .use()
        .loader('coffee-loader')
  },
}

function addStyleResource(rule) {
  rule.use('style-resource')
    .loader('style-resources-loader')
    .options({
      patterns: [
        path.resolve(__dirname, './src/styles/imports.styl'),
      ],
    })
}
