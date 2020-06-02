import Vue from "vue"
import Vuex from "vuex"
import user from "./user"
import page from "./page"
import flash from "./flash"

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    user,
    page,
    flash
  }
})
