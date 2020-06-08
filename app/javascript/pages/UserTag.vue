<template>
  <the-tag-wrapper :user="user" :registered-tags="registeredTags" />
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
      registeredTags: []
    }
  },
  watch: {
    $route() {
      this.fetchData()
    }
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    async fetchData() {
      const { userUuid } = this.$route.params
      const userRes = await this.$axios.get(`/api/v1/users/${userUuid}`)
      const { user } = userRes.data
      this.user = user

      const registeredTagsRes = await this.$axios.get(
        `/api/v1/users/${userUuid}/registered_tags`
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    }
  }
}
</script>
