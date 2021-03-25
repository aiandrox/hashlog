const state = () => ({
  isNotFound: false
})

const getters = {
  isNotFound: state => state.isNotFound
}

const mutations = {
  setIsNotFound(state, { boolean }) {
    state.isNotFound = boolean
  }
}

const actions = {
  setIsNotFound({ commit }, { boolean }) {
    commit("setIsNotFound", { boolean })
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
