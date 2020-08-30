const { environment } = require("@rails/webpacker")
const { VueLoaderPlugin } = require("vue-loader")
const vue = require("./loaders/vue")
const eslint = require("./loaders/eslint")

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin())
environment.loaders.prepend("eslint", eslint)
environment.loaders.append("vue", vue)
module.exports = environment
