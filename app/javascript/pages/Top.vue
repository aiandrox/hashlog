<template>
  <div class="top">
    <div class="main-header">
      <!-- メインヘッダー -->
      <v-container>
        <v-row>
          <v-col class="header-left text-right align-self-center" :md="5">
            <v-img class="logo" alt="Hashlog" max-width="300" src="/img/logo.png" />
            <p>いい感じのキャッチコピー</p>
            <v-btn color="primary" x-large depressed @click="pushLogin">今すぐ始める</v-btn>

            <p>人気のハッシュタグ</p>
            <p>
              <span v-for="tag in tags" :key="tag.id">#{{ tag.name + " " }}</span>
            </p>
            <v-btn color="#42a9db" dark depressed @click="guestLogin">ゲストとして試してみる</v-btn>
          </v-col>
          <v-col>
            <v-img max-width="600" src="/img/main-image.png" />
          </v-col>
        </v-row>
      </v-container>
    </div>
    <v-container class="main-content">
      <v-row>
        <v-col class="align-self-center" :md="7">
          <h2 class="mb-5">あなたはハッシュタグを付けて呟くだけ</h2>
          <p>ハッシュタグを登録した後は、あなたは今までと同じように、Twitterでハッシュタグを付けてツイートするだけです。</p>
          <p>Hashlogがあなたのツイートを自動で収集します。</p>
        </v-col>
        <v-col :md="5">
          <v-img alt="あなたはハッシュタグを付けて呟くだけ" src="/img/hashtag.png" />
        </v-col>
      </v-row>
      <v-row class="flex-row-reverse">
        <v-col class="align-self-center" :md="7">
          <h2 class="mb-5">ツイートをした日をカレンダーに記録</h2>
          <p>あなたがツイートした日をわかりやすく記録します。</p>
          <p>学習記録がひと目でわかります。</p>
        </v-col>
        <v-col :md="5">
          <v-img alt="ツイートをした日をカレンダーに記録" src="/img/calendar.png" />
        </v-col>
      </v-row>
      <v-row>
        <v-col class="align-self-center" :md="7">
          <h2 class="mb-5">リマインダーで「うっかり忘れ」を防止</h2>
          <p>もし、あなたが一定日数ツイートをしなかった場合、Hashlogからリプライが届きます。</p>
          <small>事前に1〜30日でリマインダーを設定している必要があります。</small>
        </v-col>
        <v-col :md="5">
          <v-img alt="リマインダーで「うっかり忘れ」を防止" src="/img/time.png" />
        </v-col>
      </v-row>
    </v-container>
    <!-- 利用規約ダイアログ -->
    <the-terms-dialog ref="termsDialog" />
  </div>
</template>

<script>
import theTermsDialog from "../components/TheTermsDialog"

export default {
  components: {
    theTermsDialog
  },
  data() {
    return {
      tags: []
    }
  },
  mounted() {
    document.title = "Hashlog"
    this.fetchTagsData()
  },
  methods: {
    pushLogin() {
      this.$refs.termsDialog.open()
    },
    async fetchTagsData() {
      const tagsRes = await this.$axios.get("/api/v1/tags?count=3")
      const { tags } = tagsRes.data
      this.tags = tags
    },
    async guestLogin() {
      await this.$store.dispatch("user/guestLogin")
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
.top {
  color: #3b394d;
}
.main-header {
  background-color: #fff;
  border-bottom: 20px solid #006596;
}
.main-content p {
  line-height: 1.8rem;
}
</style>
