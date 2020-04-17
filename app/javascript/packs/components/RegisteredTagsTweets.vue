<template>
  <div>
    <tweet v-for="tweet in tweets" :key="tweet.tweet_id" :tweet="tweet" :user="user"></tweet>
  </div>
</template>
<style scoped></style>
<script>
import Tweet from "./RegisteredTagsTweetsTweet";
import Axios from "axios";
export default {
  components: {
    Tweet
  },
  data: function() {
    return {
      user: {},
      tag: {},
      tweets: []
    };
  },
  computed: {
    apiEndPoint: function() {
      const id = this.$route.params["id"];
      return `/api/v1/mypage/registered_tags/${id}.json`;
    }
  },
  watch: {
    $route(to, from) {
      this.fetchTweetsData();
      this.createdTweetsPage();
    }
  },
  created: function() {
    this.fetchTweetsData();
    this.createdTweetsPage();
  },
  methods: {
    fetchTweetsData() {
      Axios.get(this.apiEndPoint).then(response => {
        const responseData = response.data;
        this.user = responseData.user;
        this.tag = responseData.registered_tag;
        this.tweets = responseData.tweets;
      });
    },
    createdTweetsPage() {
      this.$emit("created-tweets-page");
    }
  }
};
</script>
