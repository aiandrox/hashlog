<template>
  <div>
    <!-- タブ -->
    <v-tabs
      color="indigo"
      optional
    >
      <v-tab
        v-for="tag in registered_tags"
        :key="tag.name"
        :to="{ path: `/mypage/tags/${tag.id}` }"
        @click="clickTab"
      >
        {{ tag.name }}
      </v-tab>
    </v-tabs>
    <router-view @created-tweets-page="clickTab" />
  </div>
</template>
<style scoped></style>
<script>
export default {
  props: {
    registered_tags: {
      type: Array,
      default: () => {},
    },
  },
  methods: {
    clickTab() {
      this.$emit('click-tab')
    },
  },
}
</script>
