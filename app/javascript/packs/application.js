import Vue from "vue"
import App from "../App.vue"

import VueRouter from "vue-router"
import router from "./router"
Vue.use(VueRouter)

import VueAnalytics from "vue-analytics"
Vue.use(VueAnalytics, {
  id: "UA-171536655-1",
  router
})

import Vuex from "vuex"
import store from "../store/index"
Vue.use(Vuex)

import Axios from "../plugins/axios"
Vue.prototype.$axios = Axios

import customPlugin from "../plugins/custom-plugins"
Vue.mixin(customPlugin)
import dayjs from "../plugins/dayjs"
Vue.mixin(dayjs)
import veeValidate from "../plugins/vee-validate"
Vue.mixin(veeValidate)

import Vuetify from "vuetify"
import "vuetify/dist/vuetify.min.css"
import "@mdi/font/css/materialdesignicons.css"
Vue.use(Vuetify)
Vue.config.productionTip = false
const vuetify = new Vuetify({
  icons: {
    iconfont: "mdi"
  },
  theme: {
    themes: {
      light: {
        primary: "#0079b5",
        depressedButton: "#4e8baf"
      }
    }
  }
})

import sanitizeHTML from "sanitize-html"
Vue.prototype.$sanitize = sanitizeHTML

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#app",
    router,
    vuetify,
    store,
    render: h => h(App)
  })
  app.$mount("#app")
})
