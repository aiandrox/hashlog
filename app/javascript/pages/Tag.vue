<template>
  <div>
    <tab :registered-tags="registeredTags" />
    <v-container class="d-flex flex-row-reverse" row>
      <v-col cols="12" md="">
        <tag-status @push-delete="showDialog" :registered-tag="registeredTag" />
      </v-col>
      <v-spacer />
      <v-col cols="12" md="6">
        <tweets :tweets="tweets" :user="user" />
      </v-col>
    </v-container>
    <delete-dialog ref="dialog" @push-delete="deleteTag"
      >保存されていたツイートのデータは全て消えてしまいます。</delete-dialog
    >
  </div>
</template>

<script>
import axios from "axios"
import tagStatus from "../components/TagStatus"
import tab from "../components/TagsTab"
import tweets from "../components/TagsTweets"
import deleteDialog from "../components/shared/TheDeleteDialog"

export default {
  title() {
    return this.registeredTag.tag.name
  }, // 動的な名前がつけられない。
  components: {
    tagStatus,
    tab,
    tweets,
    deleteDialog
  },
  data() {
    return {
      user: {
        uuid: "",
        name: "",
        description: "",
        screenName: "",
        twitterId: "",
        privacy: "",
        role: ""
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
      const { id } = this.$route.params
      return `/api/v1/registered_tags/${id}`
    }
  },
  watch: {
    $route() {
      this.fetchData()
    }
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    async fetchData() {
      try {
        // TODO: await地獄
        const userRes = await axios.get("/api/v1/users/current")
        const user = userRes.data.user
        this.user = user

        const registeredTagsRes = await axios.get(
          `/api/v1/users/${user.uuid}/registered_tags`
        )
        const registeredTags = registeredTagsRes.data.registeredTags
        this.registeredTags = registeredTags

        const registeredTagRes = await axios.get(this.registeredTagUrl)
        const registeredTag = registeredTagRes.data.registeredTag
        this.registeredTag = registeredTag

        const tweetsRes = await axios.get(
          `/api/v1/registered_tags/${registeredTag.id}/tweets`
        )
        const tweets = tweetsRes.data.tweets
        this.tweets = tweets
      } catch (error) {
        console.log(error)
      }
    },
    showDialog() {
      this.$refs.dialog.open()
    },
    deleteTag() {
      axios
        .delete(this.registeredTagUrl)
        .then(response => {
          const responseData = response.data
          this.$router.push({ name: "mypage" })
        })
        .catch(response => {
          console.log(response)
        })
    }
  }
}
</script>
