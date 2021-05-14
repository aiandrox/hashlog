<template>
  <div>
    <!-- タブ -->
    <the-tab :registered-tags="registeredTags" />
    <!-- カレンダー -->
    <the-calendar
      ref="calendar"
      :tweet-dates="tweetDates"
      @input-date="fetchDateTweets"
    />
    <v-container class="main-content d-flex flex-row-reverse pt-0" row>
      <!-- ハッシュタグの情報 -->
      <v-col cols="12" md="4" class="px-0">
        <v-card flat>
          <tag-status
            ref="tagStatus"
            :registered-tag.sync="registeredTag"
            @push-delete="$emit('push-delete')"
            @push-update="$emit('push-update', registeredTag)"
            @push-cancel="fetchTagData"
            @push-tweet="$refs.tweetDialog.open()"
          />
        </v-card>
        <!-- 広告 -->
        <a target="_blank" rel="noopener" href="https://runteq.jp/r/FKSRkiAh">
          <v-img
            class="mt-3 d-none d-sm-block"
            alt="RUNTEQ"
            src="/img/runteq/300_50.jpg"
          />
        </a>
      </v-col>
      <!-- ツイートダイアログ -->
      <tweet-dialog
        ref="tweetDialog"
        :tweeted-day-count="registeredTag.tweetedDayCount"
        :last-tweeted-at="registeredTag.lastTweetedAt"
        :tag-name="registeredTag.tag.name"
        @create-tweet="updateTweetsData"
      />
      <!-- ツイート -->
      <v-col cols="12" md="8" class="px-0 pt-0">
        <tweets-view :tweets="tweets" :user="user" />
      </v-col>
    </v-container>
    <!-- ページネーション -->
    <div class="text-center">
      <v-pagination
        v-model="page.currentPage"
        :length="page.totalPages"
        :total-visible="7"
        @input="changePaginationPage"
      />
    </div>
    <Adsense data-ad-client="ca-pub-1391068561417780" data-ad-slot="7022358050" />
  </div>
</template>

<script>
import theCalendar from "./TheCalendar"
import tagStatus from "./TagStatus"
import theTab from "./TagsTab"
import tweetsView from "./TagsTweets"
import tweetDialog from "./TheTweetDialog"

export default {
  components: {
    theCalendar,
    tagStatus,
    theTab,
    tweetsView,
    tweetDialog
  },
  props: {},
  data() {
    return {
      user: {
        tweetId: "",
        screenName: "",
        name: "",
        description: "",
        privacy: ""
      },
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      registeredTag: {
        id: "",
        tweetedDayCount: 0,
        privacy: "",
        remindDay: 0,
        firstTweetedAt: "",
        lastTweetedAt: "",
        tag: {
          name: ""
        }
      },
      registeredTags: [],
      tweets: [],
      tweetDates: []
    }
  },
  computed: {
    isMypage() {
      return this.$route.path.includes("/mypage/")
    },
    registeredTagUrl() {
      const { tagId } = this.$route.params
      return `/api/v1/registered_tags/${tagId}`
    },
    isOpened() {
      return (
        this.user.privacy === "公開" && this.registeredTag.privacy !== "非公開"
      )
    }
  },
  watch: {
    $route() {
      this.firstRead()
    }
  },
  created() {
    this.firstRead()
  },
  methods: {
    async firstRead() {
      this.fetchRegisteredTagsData()
      this.fetchUserData()
      this.fetchTweetDates()
      this.fetchTweetsData()
      await this.fetchTagData()
      document.title = `#${this.registeredTag.tag.name} - Hashlog`
    },
    updateTweetsData() {
      this.fetchTweetDates()
      this.fetchTweetsData()
    },
    async fetchTagData() {
      const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag
    },
    async fetchTweetsData() {
      const tweetsRes = await this.$axios.get(
        `${this.registeredTagUrl}/tweets?page=1`
      )
      this.setPaginationData(tweetsRes)
      const { tweets } = tweetsRes.data
      this.tweets = tweets
    },
    // タブ用ユーザーの全てのタグ
    async fetchRegisteredTagsData() {
      if (this.isMypage) {
        const registeredTagsRes = await this.$axios.get(
          "/api/v1/users/current/registered_tags"
        )
        const { registeredTags } = registeredTagsRes.data
        this.registeredTags = registeredTags
        return
      }
      const { userUuid } = await this.$route.params
      const registeredTagsRes = await this.$axios.get(
        `/api/v1/users/${userUuid}/registered_tags`
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    // ユーザー
    async fetchUserData() {
      if (this.isMypage) {
        const userRes = await this.$axios.get("/api/v1/users/current")
        const { user } = userRes.data
        this.user = user
        return
      }
      const { userUuid } = this.$route.params
      const userRes = await this.$axios.get(`/api/v1/users/${userUuid}`)
      const { user } = userRes.data
      this.user = user
    },
    // カレンダー用日付データ
    async fetchTweetDates() {
      this.tweetDates = []
      const tweetsRes = await this.$axios.get(
        `${this.registeredTagUrl}/tweeted_ats`
      )
      const { tweetedAts } = tweetsRes.data
      tweetedAts.forEach(t => this.tweetDates.push(t.substr(0, 10)))
      this.date = ""
    },
    // カレンダーの日付の変更
    async fetchDateTweets(date) {
      this.page.currentPage = 1
      const tweetsRes = await this.$axios.get(
        `${this.registeredTagUrl}/tweets?page=1&date=${date}`
      )
      this.setPaginationData(tweetsRes)
      const { tweets } = tweetsRes.data
      this.tweets = tweets
    },
    // ページネーション
    setPaginationData(response) {
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    },
    async changePaginationPage(val) {
      this.$toTop()
      const res = await this.$axios.get(this.paginationUrl(val))
      const { tweets } = res.data
      this.tweets = tweets
    },
    paginationUrl(page) {
      if (this.$refs.calendar.date) {
        return `${this.page.requestUrl}?date=${this.$refs.calendar.date}&page=${page}`
      }
      return `${this.page.requestUrl}?page=${page}`
    }
  }
}
</script>
