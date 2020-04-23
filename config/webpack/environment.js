const { environment } = require("@rails/webpacker")
const { VueLoaderPlugin } = require("vue-loader")
// const { MomentLocalesPlugin } = require("moment-locales-webpack-plugin")
const vue = require("./loaders/vue")
const eslint = require("./loaders/eslint")

// environment.plugins.prepend(
//   "MomentLocalesWebpackPlugin",
//   MomentLocalesPlugin({
//     localesToKeep: ["ja"]
//   })
// )
// TODO: MomentLocalesWebpackPlugin
environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin())
environment.loaders.prepend("vue", vue)
environment.loaders.append("eslint", eslint)
module.exports = environment
