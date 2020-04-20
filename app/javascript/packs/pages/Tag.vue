<template>
  <div>
    <tab :registered-tags="tags" />
    <tweets :tweets="tweets" :user="user" />
  </div>
</template>

<script>
import Axios from "axios"
import Tab from "../components/TagsTab"
import Tweets from "../components/RegisteredTagsTweets"
export default {
  components: {
    Tab,
    Tweets
  },
  data() {
    return {
      user: {},
      tags: [],
      tweets: []
    }
  },
  computed: {
    apiEndPoint() {
      const { id } = this.$route.params
      return `/api/v1/mypage/tags/${id}.json`
    }
  },
  created() {
    this.fetchUserData()
    this.fetchTweetsData()
  },
  watch: {
    $route() {
      this.fetchTweetsData()
    }
  },
  methods: {
    fetchUserData() {
      Axios.get("/api/v1/mypage.json").then(response => {
        const responseData = response.data
        this.user = responseData.user
        this.tags = responseData.registered_tags
      })
    },
    fetchTweetsData() {
      Axios.get(this.apiEndPoint).then(response => {
        const responseData = response.data
        this.tweets = responseData.tweets
      })
    }
  }
}
</script>
