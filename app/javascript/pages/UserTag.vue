<template>
  <the-tag-wrapper :user="user" />
</template>

<script>
import theTagWrapper from "../components/TheTagWrapper"

export default {
  components: {
    theTagWrapper
  },
  data() {
    return {
      user: {
        uuid: "",
        description: "",
        name: "",
        screenName: "",
        twitterId: "",
        role: "",
        privacy: ""
      },
    }
  },
  watch: {
    $route() {
      this.fetchUserData()
    }
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    async fetchUserData() {
      const { userUuid } = this.$route.params
      const userRes = await this.$axios.get(`/api/v1/users/${userUuid}`)
      const { user } = userRes.data
      this.user = user
    }
  }
}
</script>
