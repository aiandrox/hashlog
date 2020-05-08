<template>
  <div>
    <tab :registered-tags="registeredTags" />
    <tag-status @push-delete="deleteTag" :registered-tag="registeredTag" />
    <tweets :tweets="tweets" :user="user" />
  </div>
</template>

<script>
import axios from "axios"
import TagStatus from "../components/TagStatus"
import Tab from "../components/TagsTab"
import Tweets from "../components/TagsTweets"
export default {
  title() {
    return this.registeredTag.tag.name
  }, // 動的な名前がつけられない。
  components: {
    TagStatus,
    Tab,
    Tweets
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
