<template>
  <div>
    <!-- タブとタグ登録ボタン -->
    <tags-tab :registered-tags="registeredTags" />
    <!-- プロフィール -->
    <profile
      ref="profile"
      :user="currentUser"
      @push-update="updateUserData"
      @push-delete="showDeleteDialog"
      @push-cancel="cancelEdit"
    />
    <!-- 削除ダイアログ -->
    <delete-dialog ref="deleteDialog" @push-delete="deleteUser">
      ツイートを含む全てのデータが消えて
      <br />復活できなくなります。
    </delete-dialog>
  </div>
</template>
<script>
import { mapGetters } from "vuex"
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
      registeredTags: []
    }
  },
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" })
  },
  async mounted() {
    await this.$store.dispatch("page/setType", "mypage")
    this.fetchRegisteredTagsData(this.currentUser)
  },
  methods: {
    async fetchRegisteredTagsData(user) {
      const registeredTagsRes = await this.$axios
        .get(`/api/v1/users/${user.uuid}/registered_tags`)
        .catch(this.$handleError)
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    updateUserData() {
      this.$store.dispatch("user/updateCurrentUser", this.currentUser)
      this.$refs.profile.finishEdit()
    },
    async cancelEdit() {
      this.$store.dispatch("user/getCurrentUserFromAPI")
    },
    showDeleteDialog() {
      this.$refs.deleteDialog.open()
    },
    deleteUser() {
      this.$store.dispatch("user/deleteCurrentUser")
      this.$router.push({ name: "top" })
    }
  }
}
</script>
