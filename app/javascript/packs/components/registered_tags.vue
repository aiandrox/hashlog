<template>
  <div>
    <!-- タブ -->
    <v-tabs color="indigo" optional>
      <v-tab
        v-for="tag in registered_tags"
        :key="tag.name"
        :to="{ path: `/mypage/tags/${tag.id}` }"
        @click="clickTab"
      >
        {{ tag.name }}
      </v-tab>
    </v-tabs>
    <router-view @created-tweets-page="clickTab"></router-view>
  </div>
</template>
<style scoped></style>
<script>
export default {
  methods: {
    clickTab: function() {
      this.$emit("click-tab");
    },
  },
  props: {
    registered_tags: {
      type: Array,
      default: () => {},
    },
  },
};
</script>
