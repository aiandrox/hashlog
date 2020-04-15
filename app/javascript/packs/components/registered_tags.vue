<template>
  <div>
    <v-tabs color="indigo" optional>
      <v-tab
        v-for="tag in registered_tags"
        :key="tag.name"
        :to="{ path: `/mypage/tags/${tag.id}` }"
      >
        {{ tag.name }}
      </v-tab>
    </v-tabs>
    <router-view />>
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
};
</script>
