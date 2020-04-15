<template>
  <div>
    <h1>マイページ</h1>
    <profile :user="user"></profile>
    <registered-tags :registered_tags="registered_tags"></registered-tags>
  </div>
</template>
<script>
import Axios from "axios";

import Profile from "../components/profile.vue";
import RegisteredTags from "../components/registered_tags.vue";

export default {
  components: {
    profile: Profile,
    "registered-tags": RegisteredTags,
  },

  data: function() {
    return {
      user: {},
      registered_tags: [],
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
        this.registered_tags = responseData.registered_tags;
      });
    },
  },
};
</script>
