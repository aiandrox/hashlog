<template>
  <div class="top">
    <!-- メインヘッダー -->
    <div class="white-zone">
      <v-container>
        <v-row>
          <v-col class="text-right align-self-center" :md="5">
            <v-img class="logo" alt="Hashlog" src="/img/logo.png" />
            <p class="title">
              ハッシュタグで
              <br class="d-block d-sm-none" />あなたの学びをキチンとする
            </p>
            <v-btn color="primary" x-large depressed @click="pushLogin"
              >今すぐ始める</v-btn
            >
            <div class="d-none d-sm-block">
              <p class="mt-10 mb-1 title">人気のハッシュタグ</p>
              <span v-for="tag in popularTags" :key="tag.id"
                >#{{ tag.name + " " }}</span
              >
            </div>
            <v-btn
              class="register-btn"
              color="#74accc"
              dark
              depressed
              @click="guestLogin"
              >ゲストとして試してみる</v-btn
            >
          </v-col>
          <v-col>
            <v-img
              class="register-btn"
              max-width="600"
              src="/img/main-image.png"
            />
          </v-col>
        </v-row>
      </v-container>
    </div>
    <!-- 最近登録されたハッシュタグ -->
    <div class="tag-zone pb-3">
      <v-container>
        <h2 class="text-center my-5">最近登録されたハッシュタグ</h2>
        <v-row>
          <v-col cols="12" md="4" v-for="tag in recentTags" :key="tag.id">
            <v-card
              flat
              hover
              color="rgba(255, 255, 255, 0.8)"
              :to="{
                name: 'userTag',
                params: { tagId: tag.id, userUuid: tag.user.uuid }
              }"
            >
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="mb-1 mt-3"
                    >#{{ tag.tag.name }}</v-list-item-title
                  >

                  <v-list-item-subtitle class="mb-3 text-right"
                    >by {{ tag.user.name }}</v-list-item-subtitle
                  >

                  <v-list-item-text>
                    <p>
                      最新のツイート：
                      <br />
                      {{ date(tag.lastTweetedAt) }}
                    </p>
                    <p>
                      ツイート総日数：{{ tag.tweetedDayCount }}日（{{
                        tag.tweetRate
                      }}%）
                    </p>
                  </v-list-item-text>
                </v-list-item-content>
              </v-list-item>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </div>
    <!-- 機能紹介 -->
    <v-container class="main-content features">
      <v-row
        v-for="(description, index) in descriptions"
        :key="index"
        :class="'flex-row' + description.line"
      >
        <v-col class="align-self-center" :md="7">
          <h2 class="mb-5">{{ description.title }}</h2>
          <div v-html="description.text" />
        </v-col>
        <v-col :md="5">
          <v-img :alt="description.title" :src="description.imgSrc" />
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
      popularTags: [],
      recentTags: []
    }
  },
  computed: {
    descriptions() {
      return [
        {
          title: "あなたはハッシュタグを付けて呟くだけ",
          imgSrc: "/img/hashtag.png",
          text:
            "<p>ハッシュタグを登録した後は、あなたは今までと同じように、Twitterでハッシュタグを付けてツイートするだけです。</p><p>Hashlogがあなたのツイートを自動で収集します。</p>",
          line: ""
        },
        {
          title: "ツイートをした日をカレンダーに記録",
          imgSrc: "/img/calendar.png",
          text:
            "<p>ツイートをした日はカレンダーに印が付きます。</p><p>あなたの学習記録がひと目でわかります。</p>",
          line: "-reverse"
        },
        {
          title: "リマインダーで「うっかり忘れ」を防止",
          imgSrc: "/img/time.png",
          text:
            "<p>もし、あなたが一定日数ツイートをしなかったときは、Hashlogからリプライが届きます。</p><small>※ 事前にリマインダーを設定しておく必要があります。</small>",
          line: ""
        }
      ]
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
      const popularTagsRes = await this.$axios.get("/api/v1/tags?count=3")
      const popularTags = popularTagsRes.data.tags
      this.popularTags = popularTags
      const recentTagsRes = await this.$axios.get(
        "/api/v1/registered_tags?count=3"
      )
      const recentTags = recentTagsRes.data.registeredTags
      this.recentTags = recentTags
    },
    async guestLogin() {
      await this.$store.dispatch("user/guestLogin")
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ゲストユーザーとしてログインしました"
      })
      this.$router.push({ name: "mypage" })
    },
    date(date) {
      if (date === null) {
        return "まだツイートはありません"
      }
      return this.$fullDateFormat(date)
    }
  }
}
</script>

<style scoped>
.top {
  color: #3b394d;
}
.logo {
  margin-top: 20px;
  margin-bottom: 20px;
}
.register-btn {
  margin-top: 20px;
  margin-bottom: 20px;
}
.white-zone {
  background-color: #fff;
}
.tag-zone {
  background-color: #5f98b9;
}
.tag-zone h2 {
  color: #fff;
}
.features p {
  line-height: 1.8rem;
}
.v-list-item__title {
  font-size: 1.3rem;
}
v-list-item-text p {
  line-height: 1.5rem;
}
</style>
