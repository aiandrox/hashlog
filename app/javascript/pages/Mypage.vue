<template>
  <div>
    <profile ref="profile" :user="user" @update-user-data="updateUserData" />
    <tags-tab :registered-tags="registeredTags" />
  </div>
</template>
<script>
import axios from "axios"
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
  mounted() {
    this.fetchUserData()
  },
  methods: {
    async fetchUserData() {
      try {
        const userRes = await axios.get("/api/v1/users/current")
        const user = userRes.data.user
        const registeredTagsRes = await axios.get(
          `/api/v1/users/${user.uuid}/registered_tags`
        )
        const registeredTags = registeredTagsRes.data.registeredTags
        this.user = user
        this.registeredTags = registeredTags
      } catch (error) {
        console.log(error)
      }
    },
    async updateUserData() {
      try {
        const res = await axios.patch(`/api/v1/users/${this.user.uuid}`, {
          user: this.user
        })
        this.$refs.profile.finishEdit()
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>
