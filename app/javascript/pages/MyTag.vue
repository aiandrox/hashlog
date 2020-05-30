<template>
  <div>
    <!-- タブ -->
    <tab :registered-tags="registeredTags" />
    <v-container class="d-flex flex-row-reverse pt-0" row>
      <!-- ハッシュタグの情報 -->
      <v-col class="hidden-sm-and-down" cols="12" md>
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
      <v-spacer />
      <!-- ツイート -->
      <v-col cols="12" md="6" class="pt-0">
        <tweets :tweets="tweets" :user="currentUser" />
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
import tagStatus from "../components/TagStatus"
import tab from "../components/TagsTab"
import tweets from "../components/TagsTweets"
import deleteDialog from "../components/shared/TheDeleteDialog"

export default {
  components: {
    tagStatus,
    tab,
    tweets,
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
  watch: {
    async $route() {
      await this.fetchData()
      document.title = `#${this.registeredTag.tag.name} | Hashlog`
    }
  },
  async mounted() {
    this.$store.dispatch("page/setType", "mypage")
    await this.fetchData()
    document.title = `#${this.registeredTag.tag.name} | Hashlog`
  },
  methods: {
    async fetchData() {
      try {
        const registeredTagsRes = await this.$axios.get(
          `/api/v1/users/${this.currentUser.uuid}/registered_tags`
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
      } catch (error) {
        console.log(error)
      }
    },
    async updateTagData() {
      try {
        await this.$axios.patch(
          `/api/v1/registered_tags/${this.registeredTag.id}`,
          {
            tag: this.registeredTag
          }
        )
        this.$refs.tagStatus.finishEdit()
        const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
        const { registeredTag } = registeredTagRes.data
        this.registeredTag = registeredTag
      } catch (error) {
        console.log(error)
      }
    },
    async fetchTagData() {
      const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag
    },
    showDeleteDialog() {
      this.$refs.deleteDialog.open()
    },
    deleteTag() {
      try {
        this.$axios.delete(this.registeredTagUrl)
        this.$router.push({ name: "mypage" })
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>
