<template>
  <div>
    <v-expand-transition>
      <profile v-if="showProfile" :user="user" />
    </v-expand-transition>
    <registered-tags :registered-tags="registeredTags" @click-tab="removeProfile" />
  </div>
</template>
<script>
import Axios from "axios"

import Profile from "../components/shared/Profile.vue"
import RegisteredTags from "../components/RegisteredTags.vue"

export default {
  components: {
    profile: Profile,
    "registered-tags": RegisteredTags
  },

  data() {
    return {
      profileShow: true,
      user: {},
      registeredTags: []
    }
  },

  watch: {
    $route(to) {
      if (to.name === "mypage") {
        this.showProfile()
      } else if (to.name === "mypage_registered_tags") {
        this.removeProfile()
      }
    }
  },

  created() {
    this.updateContents()
  },

  methods: {
    updateContents() {
      Axios.get("/api/v1/mypage.json").then(response => {
        const responseData = response.data
        this.user = responseData.user
        this.registered_tags = responseData.registered_tags
      })
    },
    removeProfile() {
      this.show_profile = false
    },
    showProfile() {
      this.profileShow = true
    }
  }
}
</script>
