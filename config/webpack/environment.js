const { environment } = require("@rails/webpacker")
const { VueLoaderPlugin } = require("vue-loader")
const vue = require("./loaders/vue")

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin())
environment.loaders.append("vue", vue)
environment.loaders.delete('nodeModules')
module.exports = environment
