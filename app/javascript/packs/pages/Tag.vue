<template>
  <div>
    <tab :registered-tags="tags" />
    <tweets :tweets="tweets" :user="user" />
  </div>
</template>

<script>
import Axios from "axios"
import Tab from "../components/TagsTab"
import Tweets from "../components/TagsTweets"
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
  watch: {
    $route() {
      this.fetchData()
    }
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    // TODO: リクエストTweet.idが2大きくなる
    fetchData() {
      Axios.get(this.apiEndPoint).then(response => {
        const responseData = response.data
        this.user = responseData.user
        this.tags = responseData.registered_tags
        this.tag = responseData.registered_tag
        this.tweets = responseData.tweets
      })
    }
  }
}
</script>
