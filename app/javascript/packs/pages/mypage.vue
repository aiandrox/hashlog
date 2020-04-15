<template>
  <div>
    <h1>マイページ</h1>
    <profile :user="user"></profile>
    <tweets :tags="tags"></tweets>
  </div>
</template>
<script>
import Axios from "axios";

import Profile from "../components/profile.vue";
import Tweets from "../components/tweets.vue";

export default {
  components: {
    profile: Profile,
    tweets: Tweets,
  },

  data: function() {
    return {
      user: {},
      tags: [],
    };
  },

  created: function() {
    this.updateContents();
  },

  methods: {
    updateContents() {
      Axios.get("/api/v1/mypage.json").then((response) => {
        const responseData = response.data;
        console.log(responseData);
        this.user = responseData.user;
        this.tags = responseData.tags;
      });
    },
  },
};
</script>
