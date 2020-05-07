<template>
  <div>
    <profile :user="user" />
    <tags-tab :registered-tags="registeredTags" />
  </div>
</template>
<script>
import axios from "axios"
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
    fetchUserData() {
      axios
        .get("/api/v1/users/current")
        .then(response => {
          const responseData = response.data
          this.user = responseData.user
        })
        .catch(response => {
          console.log(response)
        })
    }
  }
}
</script>
