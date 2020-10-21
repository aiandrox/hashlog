import axios from "../plugins/axios"

const state = () => ({
  currentUser: ""
})

const getters = {
  currentUser: state => state.currentUser
}

const mutations = {
  setCurrentUser(state, user) {
    state.currentUser = user
  }
}

const actions = {
  getCurrentUser({ dispatch, state }) {
    const { currentUser } = state
    if (currentUser) {
      return currentUser
    }
    return dispatch("getCurrentUserFromAPI")
  },
  async getCurrentUserFromAPI({ commit }) {
    try {
      const response = await axios.get("/api/v1/users/current")
      commit("setCurrentUser", response.data.user)
      return response.data.user
    } catch (err) {
      return null
    }
  },
  async updateCurrentUser({ commit }, userData) {
    try {
      const response = await axios.patch("/api/v1/users/current", {
        user: userData
      })
      const { user } = response.data
      commit("setCurrentUser", user)
      return user
    } catch (error) {
      return null // バリデーションエラー
    }
  },
  async fetchTwitterDataToCurrentUser({ commit }) {
    const response = await axios.patch("/api/v1/users/current/twitter_data")
    const { user } = response.data
    commit("setCurrentUser", user)
    return user
  },
  async deleteCurrentUser({ commit }) {
    await axios.delete("/api/v1/users/current")
    commit("setCurrentUser", null)
  },
  async guestLogin({ commit }) {
    const response = await axios.post("/api/v1/guest_login")
    const { user } = response.data
    commit("setCurrentUser", user)
    return user
  },
  async logout({ commit }) {
    await axios.delete("/api/v1/logout")
    commit("setCurrentUser", null)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
