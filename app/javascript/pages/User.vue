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
  title: "マイページ",
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
  computed: {
    userUrl() {
      const { userUuid } = this.$route.params
      return `/api/v1/users/${userUuid}`
    }
  },
  mounted() {
    this.$store.dispatch("page/setType", "normal")
    this.fetchUserData()
  },
  methods: {
    async fetchUserData() {
      try {
        const userRes = await this.$axios.get(this.userUrl)
        const { user } = userRes.data
        this.user = user
        const registeredTagsRes = await this.$axios.get(
          `/api/v1/users/${user.uuid}/registered_tags`
        )
        const { registeredTags } = registeredTagsRes.data
        this.registeredTags = registeredTags
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>
