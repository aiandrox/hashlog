<template>
  <div>
    <!-- タブ -->
    <tab :registered-tags="registeredTags" />
    <v-container class="d-flex flex-row-reverse pt-0" row>
      <!-- ハッシュタグの情報 -->
      <v-col class="hidden-sm-and-down" cols="12" md>
        <v-card flat>
          <tag-status ref="tagStatus" :registered-tag="registeredTag" />
        </v-card>
      </v-col>
      <v-spacer />
      <!-- ツイート -->
      <v-col cols="12" md="6" class="pt-0">
        <tweets :tweets="tweets" :user="user" />
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
  </div>
</template>

<script>
import tagStatus from "../components/TagStatus"
import tab from "../components/TagsTab"
import tweets from "../components/TagsTweets"

export default {
  components: {
    tagStatus,
    tab,
    tweets
  },
  data() {
    return {
      drawer: true,
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      user: {
        uuid: "",
        description: "",
        name: "",
        screenName: "",
        twitterId: "",
        role: "",
        privacy: ""
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
    this.$store.dispatch("page/setType", "normal")
    await this.fetchData()
    document.title = `#${this.registeredTag.tag.name} - ${this.user.name} | Hashlog`
  },
  methods: {
    async fetchData() {
      try {
        const { userUuid } = this.$route.params
        const userRes = await this.$axios.get(`/api/v1/users/${userUuid}`)
        const { user } = userRes.data
        this.user = user

        const registeredTagsRes = await this.$axios.get(
          `/api/v1/users/${userUuid}/registered_tags`
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
    async fetchTagData() {
      const registeredTagRes = await this.$axios.get(this.registeredTagUrl)
      const { registeredTag } = registeredTagRes.data
      this.registeredTag = registeredTag
    }
  }
}
</script>
