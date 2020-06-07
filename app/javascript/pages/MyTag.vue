<template>
  <div>
    <the-tag-wrapper
      ref="tagWrapper"
      :user="currentUser"
      :registered-tags="registeredTags"
      @push-delete="showDeleteDialog"
      @push-update="updateTagData"
    />
    <!-- 削除ダイアログ -->
    <delete-dialog ref="deleteDialog" @push-delete="deleteTag">
      保存されていたツイートのデータが
      <br />全て消えてしまいます。
    </delete-dialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import theTagWrapper from "../components/TheTagWrapper"
import deleteDialog from "../components/shared/TheDeleteDialog"

export default {
  components: {
    theTagWrapper,
    deleteDialog
  },
  data() {
    return {
      registeredTags: []
    }
  },
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" }),
    registeredTagUrl() {
      const { tagId } = this.$route.params
      return `/api/v1/registered_tags/${tagId}`
    }
  },
  mounted() {
    this.fetchRegisteredTagsData()
  },
  watch: {
    $route() {
      this.fetchRegisteredTagsData()
    }
  },
  methods: {
    // タプ用ユーザーの全てのタグ
    async fetchRegisteredTagsData() {
      const registeredTagsRes = await this.$axios.get(
        "/api/v1/users/current/registered_tags"
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    // データ更新
    async updateTagData(updateRegisteredTag) {
      const registeredTagRes = await this.$axios.patch(this.registeredTagUrl, {
        tag: updateRegisteredTag
      })
      this.$refs.tagWrapper.$refs.tagStatus.finishEdit()
      const { registeredTag } = registeredTagRes.data
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ハッシュタグの設定を更新しました"
      })
    },
    // データ削除
    showDeleteDialog() {
      this.$refs.deleteDialog.open()
    },
    async deleteTag() {
      await this.$axios.delete(this.registeredTagUrl)
      this.$router.push({ name: "mypage" })
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ハッシュタグを削除しました"
      })
    }
  }
}
</script>
