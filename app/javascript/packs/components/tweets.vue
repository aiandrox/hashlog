<template>
  <div>
    <div v-for="tweet in tweets" :key="tweet.id" v-html="tweet.oembed"></div>
  </div>
</template>
<style scoped></style>
<script>
import Axios from "axios";
export default {
  data: function() {
    return {
      tag: {},
      tweets: [],
    };
  },
  computed: {
    apiEndPoint: function() {
      const id = this.$route.params["id"];
      return `/api/v1/mypage/registered_tags/${id}.json`;
    },
  },

  created: function() {
    this.fetchData();
    this.createdTweetsPage();
  },

  methods: {
    fetchData() {
      Axios.get(this.apiEndPoint).then((response) => {
        const responseData = response.data;
        this.tag = responseData.registered_tag;
        this.tweets = responseData.tweets;
      });
    },
    createdTweetsPage: function() {
      this.$emit("created-tweets-page");
    },
  },
};
</script>
