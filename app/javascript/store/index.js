import Vue from "vue"
import Vuex from "vuex"
import user from "./user"
import page from "./page"

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    user,
    page
  }
})
