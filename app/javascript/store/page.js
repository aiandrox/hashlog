const state = () => ({
  // "normal", "mypage"
  type: "normal"
})

const getters = {
  type: state => state.type
}

const mutations = {
  setType(state, type) {
    state.type = type
  }
}

const actions = {
  setType({ commit }, type) {
    commit("setType", type)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
