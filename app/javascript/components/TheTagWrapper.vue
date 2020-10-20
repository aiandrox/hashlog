<template>
  <div>
    <!-- タブ -->
    <the-tab :registered-tags="registeredTags" @select-tab="firstRead" @create-tag="firstRead" />
    <!-- カレンダー -->
    <the-calendar ref="calendar" :tweet-dates="tweetDates" @input-date="fetchDateTweets" />
    <v-container class="main-content d-flex flex-row-reverse pa-0" row>
      <!-- ハッシュタグの情報 -->
      <v-col cols="12" md="4" class="px-0">
        <v-card flat>
          <tag-status
            ref="tagStatus"
            :registered-tag="registeredTag"
            @push-delete="$emit('push-delete')"
            @push-update="$emit('push-update', registeredTag)"
            @push-cancel="fetchTagData"
          />
        </v-card>
        <!-- 広告 -->
        <a target="_blank" href="https://runteq.jp/r/FKSRkiAh">
          <v-img class="mt-3 d-none d-sm-block" alt="RUNTEQ" src="/img/runteq/300_50.jpg" />
        </a>
      </v-col>
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
  </div>
</template>

<script>
import theCalendar from "./TheCalendar"
import tagStatus from "./TagStatus"
import theTab from "./TagsTab"
import tweetsView from "./TagsTweets"

export default {
  components: {
    theCalendar,
    tagStatus,
    theTab,
    tweetsView
  },
  props: {
    user: {
      type: Object,
      default: () => {},
      required: true
    },
    registeredTags: {
      type: Array,
      default: () => [],
      required: true
    }
  },
  data() {
    return {
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      registeredTag: {
        id: "",
        tweetedDayCount: "",
        privacy: "",
        remindDay: "",
        firstTweetedAt: "",
        lastTweetedAt: "",
        tag: {
          name: ""
        }
      },
      tweets: [],
      tweetDates: []
    }
  },
  computed: {
    registeredTagUrl() {
      const { tagId } = this.$route.params
      return `/api/v1/registered_tags/${tagId}`
    }
  },
  mounted() {
    this.firstRead()
  },
  methods: {
    async firstRead() {
      this.fetchTweetDates()
      this.fetchTweetsData()
      await this.fetchTagData()
      document.title = `#${this.registeredTag.tag.name} - Hashlog`
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
    // カレンダー用全てのツイート
    async fetchTweetDates() {
      this.tweetDates = []
      const tweetsRes = await this.$axios.get(`${this.registeredTagUrl}/tweeted_ats`)
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
