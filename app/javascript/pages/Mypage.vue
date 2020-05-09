<template>
  <div>
    <!-- タブとタグ登録ボタン -->
    <tags-tab :registered-tags="registeredTags" />
    <!-- プロフィール -->
    <profile
      ref="profile"
      :user="user"
      @update-user-data="updateUserData"
      @push-delete="showDeleteDialog"
    />
    <delete-dialog ref="deleteDialog" @push-delete="deleteUser">
      ツイートを含む全てのデータが消えて
      <br />復活できなくなります。
    </delete-dialog>
  </div>
</template>
<script>
import axios from "axios"
import profile from "../components/Profile"
import tagsTab from "../components/TagsTab"
import deleteDialog from "../components/shared/TheDeleteDialog"

export default {
  title: "マイページ",
  components: {
    profile,
    tagsTab,
    deleteDialog
  },
  data() {
    return {
      loading: false,
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
    updateUserData() {
      try {
        axios.patch(`/api/v1/users/${this.user.uuid}`, {
          user: this.user
        })
        this.$refs.profile.finishEdit()
      } catch (error) {
        console.log(error)
      }
    },
    showDeleteDialog() {
      this.$refs.deleteDialog.open()
    },
    deleteUser() {
      axios
        .delete(`/api/v1/users/${this.user.uuid}`)
        .then(response => {
          this.$router.push({ name: "top" })
        })
        .catch(response => {
          console.log(response)
        })
    }
  }
}
</script>
