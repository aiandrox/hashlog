<template>
  <div class="top">
    <!-- メインヘッダー -->
    <div class="white-zone">
      <v-container>
        <v-row>
          <v-spacer />
          <v-col class="text-right align-self-center" cols="12" md="5">
            <v-img class="mb-8" alt="Hashlog" src="/img/logo.png" />
            <p class="title">
              ハッシュタグで
              <br class="d-block d-sm-none">あなたの学びをキチンとする
            </p>
            <v-btn
              class="mb-5"
              color="primary"
              x-large
              depressed
              @click="pushLogin"
            >今すぐ始める</v-btn>
            <br class="d-block d-sm-none">
            <p class="mb-5 d-none d-sm-block features">
              ハッシュタグを登録するだけで
              <br>あなたの継続を可視化できる <br>Twitter連携型
              学習記録サービス
            </p>
            <v-btn
              color="#74accc"
              dark
              depressed
              href="https://hashlog.work/users/eXlMWq--Uh5r/tags/196"
            >お知らせ</v-btn>
          </v-col>
          <v-col cols="12" md="6">
            <v-img max-width="600" src="/img/main-image.png" />
          </v-col>
          <v-spacer />
        </v-row>
      </v-container>
    </div>
    <!-- 最近登録されたハッシュタグ -->
    <div class="tag-zone pb-3">
      <v-container>
        <h2 class="text-center my-5">最近登録されたハッシュタグ</h2>
        <v-row>
          <v-col v-for="tag in recentTags" :key="tag.id" cols="12" md="4">
            <v-card
              flat
              hover
              color="rgba(255, 255, 255, 0.8)"
              @click="pushTagCard(tag)"
            >
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title
                    class="mb-1 mt-3"
                  >#{{ tag.tag.name }}</v-list-item-title>

                  <v-list-item-subtitle
                    class="mb-3 text-right"
                  >by {{ tag.user.name }}</v-list-item-subtitle>

                  <v-card-text class="body-1 my-0">
                    <p>
                      最新のツイート：
                      <br>
                      {{ date(tag.lastTweetedAt) }}
                    </p>
                    <p class="mb-0">
                      ツイート総日数：{{ tag.tweetedDayCount }}日（{{
                        tag.tweetRate
                      }}%）
                    </p>
                  </v-card-text>
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
import { mapGetters } from "vuex"
import theTermsDialog from "../components/TheTermsDialog"

export default {
  components: {
    theTermsDialog
  },
  data() {
    return {
      recentTags: []
    }
  },
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" }),
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
            "<p>もし、あなたが一定日数ツイートをしなかったときは、Hashlogからメンションが届きます。</p><small>※ 事前にリマインダーを設定しておく必要があります。</small>",
          line: ""
        }
      ]
    }
  },
  mounted() {
    document.title
      = "Hashlog（ハッシュログ） - あなたの継続を可視化できる Twitter連携型 学習記録サービス"
    this.fetchTagsData()
  },
  methods: {
    pushLogin() {
      if (this.currentUser) {
        this.$router.push({ name: "mypage" })
      } else {
        this.$refs.termsDialog.open()
      }
    },
    async fetchTagsData() {
      const recentTagsRes = await this.$axios.get(
        "/api/v1/registered_tags?count=3"
      )
      const recentTags = recentTagsRes.data.registeredTags
      this.recentTags = recentTags
    },
    pushTagCard(tag) {
      this.$toTop()
      this.$router.push({
        name: "userTag",
        params: { tagId: tag.id, userUuid: tag.user.uuid }
      })
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
.tag-zone p {
  line-height: 1.5rem;
}
</style>
