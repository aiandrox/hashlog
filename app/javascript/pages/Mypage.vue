<template>
  <div>
    <profile :user="user" />
    <tags-tab :registered-tags="registeredTags" />
  </div>
</template>
<script>
import Axios from "axios"
import Profile from "../components/Profile"
import TagsTab from "../components/TagsTab"

export default {
  title: "マイページ",
  components: {
    Profile,
    TagsTab
  },
  data() {
    return {
      user: {},
      registeredTags: []
    }
  },
  mounted() {
    this.fetchUserData()
  },
  methods: {
    fetchUserData() {
      Axios.get("/api/v1/mypage")
        .then(response => {
          const responseData = response.data
          this.user = responseData.user
          this.registeredTags = responseData.registered_tags
        })
        .catch(response => {
          console.log(response)
        })
    }
  }
}
</script>
