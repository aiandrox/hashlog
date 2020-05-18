<template>
  <div>
    <!-- タブとタグ登録ボタン -->
    <tags-tab :registered-tags="registeredTags" />
    <!-- プロフィール -->
    <profile
      ref="profile"
      :user="user"
      @push-update="updateUserData"
      @push-delete="showDeleteDialog"
      @push-cancel="cancelEdit"
    />
    <delete-dialog ref="deleteDialog" @push-delete="deleteUser">
      ツイートを含む全てのデータが消えて
      <br />復活できなくなります。
    </delete-dialog>
  </div>
</template>
<script>
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
        const userRes = await this.$axios.get("/api/v1/users/current")
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
    },
    async updateUserData() {
      try {
        await this.$axios.patch(`/api/v1/users/${this.user.uuid}`, {
          user: this.user
        })
        this.$refs.profile.finishEdit()
      } catch (error) {
        console.log(error)
      }
    },
    // TODO: APIを叩かずに実装したい
    async cancelEdit() {
      const userRes = await this.$axios.get(`/api/v1/users/${this.user.uuid}`)
      const { user } = userRes.data
      this.user = user
    },
    showDeleteDialog() {
      this.$refs.deleteDialog.open()
    },
    async deleteUser() {
      try {
        await this.$axios.delete(`/api/v1/users/${this.user.uuid}`)
        this.$router.push({ name: "top" })
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>
