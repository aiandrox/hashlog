import Vue from "vue"
import App from "../App.vue"

import VueRouter from "vue-router"
import router from "./router"
Vue.use(VueRouter)

// import Vuex from "vuex"
// Import store from './store.js'
// Vue.use(Vuex)

import Axios from "axios"
import VueAxiosPlugin from "../plugins/vue-axios"
Vue.use(VueAxiosPlugin, { axios: Axios })

import titlePlugin from "../plugins/page-title"
Vue.mixin(titlePlugin)

import dayjs from "../plugins/dayjs"
Vue.mixin(dayjs)

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
        primary: "#E53935",
        secondary: "#FFCDD2",
        accent: "#3F51B5"
      }
    }
  }
})

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#app",
    router,
    vuetify,
    // Store: store,
    render: h => h(App)
  })
  app.$mount("#app")
})
