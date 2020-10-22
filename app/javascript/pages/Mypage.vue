<template>
  <div>
    <!-- タブとタグ登録ボタン -->
    <tags-tab :registered-tags="registeredTags" />
    <!-- プロフィール -->
    <profile
      ref="profile"
      :user="currentUser"
      @click-privacy="togglePrivacy"
      @push-update="updateUserData"
      @push-delete="$refs.deleteDialog.open()"
      @push-cancel="cancelEdit"
      @push-twitter-update="$refs.updateDialog.open()"
    />
    <!-- 削除ダイアログ -->
    <delete-dialog ref="deleteDialog" @push-delete="deleteUser">
      ツイートを含む全てのデータが消えて
      <br>復活できなくなります。
    </delete-dialog>
    <!-- Twitterデータ更新ダイアログ -->
    <update-dialog ref="updateDialog" @push-update="fetchTwitterData" />
  </div>
</template>
<script>
import { mapGetters } from "vuex"
import profile from "../components/Profile"
import tagsTab from "../components/TagsTab"
import deleteDialog from "../components/shared/TheDeleteDialog"
import updateDialog from "../components/TheProfileUpdateDialog"

export default {
  components: {
    profile,
    tagsTab,
    deleteDialog,
    updateDialog
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
  mounted() {
    if (document.cookie.includes("logged_in=1")) {
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ログインしました"
      })
      document.cookie = "logged_in=;path=/;max-age=0;"
    }
    document.title = "マイページ - Hashlog"
    this.fetchRegisteredTagsData(this.currentUser)
  },
  methods: {
    async fetchRegisteredTagsData() {
      const registeredTagsRes = await this.$axios.get(
        "/api/v1/users/current/registered_tags"
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    async updateUserData() {
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ユーザー情報を更新しました"
      })
      await this.$store.dispatch("user/updateCurrentUser", this.currentUser)
      this.$refs.profile.finishEdit()
    },
    cancelEdit() {
      this.$store.dispatch("user/getCurrentUserFromAPI")
    },
    async fetchTwitterData() {
      try {
        await this.$store.dispatch("user/fetchTwitterDataToCurrentUser")
        this.$store.dispatch("flash/setFlash", {
          type: "success",
          message: "ユーザー情報を更新しました"
        })
      } catch (error) {
        const [errorMessage] = error.response.data.error.messages
        this.$store.dispatch("flash/setFlash", {
          type: "error",
          message: errorMessage
        })
      } finally {
        this.$refs.updateDialog.close()
      }
    },
    async deleteUser() {
      await this.$store.dispatch("user/deleteCurrentUser")
      this.$router.push({ name: "top" })
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ユーザーを削除しました"
      })
    },
    togglePrivacy() {
      if (this.currentUser.privacy === "公開") {
        this.currentUser.privacy = "非公開"
      } else {
        this.currentUser.privacy = "公開"
      }
    }
  }
}
</script>
