<template>
  <div>
    <!-- タブ -->
    <the-tab :registered-tags="registeredTags" />
    <!-- カレンダー -->
    <the-calendar :tweets="tweets" />
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
      drawer: true,
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
      tweets: []
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
    async firstRead() {
      await this.fetchData()
      document.title = `#${this.registeredTag.tag.name} | Hashlog`
    },
    async fetchData() {
      const registeredTagsRes = await this.$axios.get(
        "/api/v1/users/current/registered_tags"
      )
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags

      const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag

      const tweetsRes = await this.$axios.get(
        `/api/v1/registered_tags/${registeredTag.id}/tweets`
      )
      this.$setPaginationData(tweetsRes)
      const { tweets } = tweetsRes.data
      this.tweets = tweets
    },
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
    async fetchTagData() {
      const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag
    },
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
