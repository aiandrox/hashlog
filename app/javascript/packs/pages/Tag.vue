<template>
  <div>
    <v-btn class="ma-2" outlined color="success" @click="deleteTag">
      <v-icon left>mdi-delete</v-icon>削除
    </v-btn>
    <v-btn class="ma-2" outlined color="success">
      <v-icon left>mdi-cog</v-icon>設定
    </v-btn>
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
    // TODO: 多分、registered_tagリソースは同じURLになる
    getUrl() {
      const { id } = this.$route.params
      return `/api/v1/mypage/tags/${id}`
    },
    deleteUrl() {
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
    fetchData() {
      Axios.get(this.getUrl)
        .then(response => {
          const responseData = response.data
          this.user = responseData.user
          this.tags = responseData.registered_tags
          this.tag = responseData.registered_tag
          this.tweets = responseData.tweets
        })
        .catch(response => {
          console.log(response)
        })
    },
    deleteTag() {
      Axios.delete(this.deleteUrl)
        .then(response => {
          const responseData = response.data
          this.$router.push({ name: "/mypage" })
        })
        .catch(response => {
          console.log(response)
        })
    }
  }
}
</script>
