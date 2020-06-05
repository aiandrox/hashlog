<template>
  <div>
    <div class="main-header">
      <!-- メインヘッダー -->
      <v-container>
        <v-row>
          <v-col class="discription text-right">
            <v-img class="logo" alt="Hashlog" max-width="300" src="/img/logo.png" />
            <p>いい感じのキャッチコピー</p>
            <v-btn class="ma-2" color="primary" depressed>今すぐ始める</v-btn>
            <v-btn class="ma-2" color="#42a9db" dark depressed @click="guestLogin">ゲストログイン</v-btn>
          </v-col>
          <v-col>
            <v-img max-width="600" src="/img/main-image.png" />
          </v-col>
        </v-row>
      </v-container>
    </div>
    <v-container>
      <v-row>
        <v-col>
          あ
          <br />あ
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />あ
        </v-col>
        <v-col>いいい</v-col>
        <v-col>ううう</v-col>
      </v-row>
    </v-container>
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
    },
    async guestLogin() {
      await this.$axios.post("/api/v1/guest_login")
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ゲストユーザーとしてログインしました"
      })
      this.$router.push({ name: "mypage" })
      this.$toTop()
    }
  }
}
</script>

<style scoped>
.main-header {
  background-color: #fff;
  border-bottom: 20px solid #006596;
}
.discription {
  margin-top: 100px;
}
</style>
