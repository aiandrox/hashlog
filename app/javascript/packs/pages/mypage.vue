<template>
  <div>
    <v-expand-transition>
      <profile :user="user" v-if="show_profile" />
    </v-expand-transition>
    <registered-tags
      :registered_tags="registered_tags"
      @click-tab="removeProfile"
    />
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
      show_profile: true,
      user: {},
      registered_tags: [],
    };
  },

  watch: {
    $route(to, from) {
      if (to.name == "mypage") {
        this.showProfile();
      }
    },
  },

  created: function() {
    this.updateContents();
  },

  methods: {
    updateContents() {
      Axios.get("/api/v1/mypage.json").then((response) => {
        const responseData = response.data;
        this.user = responseData.user;
        this.registered_tags = responseData.registered_tags;
      });
    },
    removeProfile() {
      this.show_profile = false;
    },
    showProfile() {
      this.show_profile = true;
    },
  },
};
</script>
