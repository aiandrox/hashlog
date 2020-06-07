<template>
  <div>
    <!-- タブ -->
    <the-tab :registered-tags="registeredTags" />
    <!-- カレンダー -->
    <the-calendar :tweet-dates="tweetDates" @input-date="fetchDateTweets" />
    <v-container class="main-content d-flex flex-row-reverse pt-0" row>
      <!-- ハッシュタグの情報 -->
      <v-col class="hidden-sm-and-down" cols="12" md="4">
        <v-card flat>
          <tag-status
            ref="tagStatus"
            :registered-tag="registeredTag"
            @push-delete="showDeleteDialog"
            @push-update="updateTagData"
            @push-cancel="fetchTagData"
          />
        </v-card>
      </v-col>
      <!-- ツイート -->
      <v-col cols="12" md="8" class="pt-0">
        <tweets-view :tweets="tweets" :user="currentUser" />
      </v-col>
    </v-container>
    <!-- ページネーション -->
    <div class="text-center">
      <v-pagination
        v-model="page.currentPage"
        :length="page.totalPages"
        :total-visible="7"
        @input="$changePaginationPage"
      />
    </div>
    <!-- 削除ダイアログ -->
    <delete-dialog ref="deleteDialog" @push-delete="deleteTag">
      保存されていたツイートのデータが
      <br />全て消えてしまいます。
    </delete-dialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import theCalendar from "../components/TheCalendar"
import tagStatus from "../components/TagStatus"
import theTab from "../components/TagsTab"
import tweetsView from "../components/TagsTweets"
import deleteDialog from "../components/shared/TheDeleteDialog"

export default {
  components: {
    theCalendar,
    tagStatus,
    theTab,
    tweetsView,
    deleteDialog
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
      registeredTags: [],
      tweets: [],
      tweetDates: []
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
    this.firstRead()
  },
  watch: {
    $route() {
      this.firstRead()
    }
  },
  methods: {
    // 描画時の処理
    async firstRead() {
      this.fetchRegisteredTagsData()
      this.fetchTweetDates()
      this.fetchTweetsData()
      await this.fetchTagData()
      document.title = `#${this.registeredTag.tag.name} | Hashlog`
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
      this.$setPaginationData(tweetsRes)
      const { tweets } = tweetsRes.data
      this.tweets = tweets
    },
    // タプ用ユーザーの全てのタグ
    async fetchRegisteredTagsData() {
      const registeredTagsRes = await this.$axios.get(
        "/api/v1/users/current/registered_tags"
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    // カレンダー用全てのツイート
    async fetchTweetDates() {
      this.tweetDates = []
      const { tagId } = this.$route.params
      const tweetsRes = await this.$axios.get(`${this.registeredTagUrl}/tweets`)
      const { tweets } = tweetsRes.data
      tweets.forEach(t => this.tweetDates.push(t.tweetedAt.substr(0, 10)))
      this.date = ""
    },
    // カレンダーの日付の変更
    async fetchDateTweets(date) {
      const tweetsRes = await this.$axios.get(
        `${this.registeredTagUrl}/tweets?page=1&date=${date}`
      )
      this.$setPaginationData(tweetsRes)
      const { tweets } = tweetsRes.data
      this.tweets = tweets
    },
    // データ更新
    async updateTagData() {
      const registeredTagRes = await this.$axios.patch(this.registeredTagUrl, {
        tag: this.registeredTag
      })
      this.$refs.tagStatus.finishEdit()
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag
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
