<template>
  <div>
    <v-tabs color="indigo">
      <v-tab v-for="tag in this.tags" :key="tag.name">
        {{ tag.name }}
      </v-tab>
    </v-tabs>
  </div>
</template>
<style scoped></style>
<script>
export default {
  props: {
    tags: {
      type: Array,
      default: () => {},
    },
  },
};
</script>
