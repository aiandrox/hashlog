<template>
  <div>
    <v-btn text href="/api/v1/oauth/twitter">ログイン</v-btn>
    <v-btn text :to="{ name: 'mypage' }">マイページ</v-btn>
    <v-btn text :to="{ name: 'user', params: { userUuid: 'HTagphtz9-sM' } }">ユーザーページ</v-btn>
    <v-btn text>ログアウト</v-btn>
    人気ハッシュタグ{{ tags }}
  </div>
</template>

<script>
export default {
  data: () => ({
    tags: []
  }),
  mounted() {
    document.title = "Hashlog"
    this.fetchTagsData()
  },
  methods: {
    async fetchTagsData() {
      const tagsRes = await this.$axios.get("/api/v1/tags?count=3")
      const { tags } = tagsRes.data
      this.tags = tags
    }
  }
}
</script>
