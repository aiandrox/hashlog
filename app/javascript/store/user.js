import axios from "axios"

const state = () => ({
  currentUser: ""
})

const getters = {
  currentUser: state => state.currentUser
}

const mutations = {
  setCurrentUser(state, currentUser) {
    state.currentUser = currentUser
  }
}

const actions = {
  async signup({ commit }, userInfo) {
    try {
      const response = await this.$axios.post("/api/v1/users", {
        user: userInfo
      })
      commit("setCurrentUser", response.data.user)
      return response.data.user
    } catch (err) {
      commit("setCurrentUser", null)
      return Promise.reject(err)
    }
  },

  // async login({ commit }, userInfo) {
  //   try {
  //     const response = await this.$axios.post("/api/v1/user_session", userInfo)
  //     commit("setCurrentUser", response.data.user)
  //   } catch (err) {
  //     commit("setCurrentUser", null)
  //     return Promise.reject(err)
  //   }
  // },

  async getCurrentUser({ commit, state }) {
    const currentUser = state.currentUser
    if (currentUser) {
      return currentUser
    }
    try {
      const response = await axios.get("/api/v1/users/current")
      commit("setCurrentUser", response.data.user)
      return response.data.user
    } catch (err) {
      commit("setCurrentUser", null)
      return null
    }
  },
  async updateCurrentUser({ commit, state }, userData) {
    try {
      const response = await axios.patch(
        `/api/v1/users/${state.currentUser.uuid}`,
        {
          user: userData
        }
      )
      commit("setCurrentUser", response.data.user)
      return response.data.user
    } catch (error) {
      return null // バリデーションエラー
    }
  },
  async deleteCurrentUser({ commit, state }) {
    await axios.delete(`/api/v1/users/${state.currentUser.uuid}`)
    commit("setCurrentUser", null)
  },
  async logout({ commit }) {
    await this.$axios.delete("/api/v1/user_session")
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
