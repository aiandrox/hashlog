<template>
  <div>
    <!-- タブとタグ登録ボタン -->
    <tags-tab :registered-tags="registeredTags" />
    <!-- プロフィール -->
    <profile ref="profile" :user="user" />
  </div>
</template>
<script>
import profile from "../components/Profile"
import tagsTab from "../components/TagsTab"

export default {
  components: {
    profile,
    tagsTab
  },
  data() {
    return {
      user: {
        uuid: "",
        name: "",
        description: "",
        screenName: "",
        twitterId: "",
        privacy: "",
        role: ""
      },
      registeredTags: []
    }
  },
  mounted() {
    this.firstRead()
  },
  watch: {
    $route() {
      this.firstRead()
    }
  },
  methods: {
    async firstRead() {
      await this.fetchUserData()
      document.title = `${this.user.name}のユーザーページ - Hashlog`
    },
    async fetchUserData() {
      const { userUuid } = this.$route.params
      const userRes = await this.$axios.get(`/api/v1/users/${userUuid}`)
      const { user } = userRes.data
      this.user = user

      const registeredTagsRes = await this.$axios.get(
        `/api/v1/users/${user.uuid}/registered_tags`
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    }
  }
}
</script>
