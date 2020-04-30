<template>
  <v-tabs>
    <v-tab
      v-for="tag in registeredTags"
      :key="tag.name"
      :to="{ name: 'tag', params: { id: tag.id } }"
      >{{ tag.name }}</v-tab
    >
  </v-tabs>
</template>
<script>
export default {
  props: {
    registeredTags: {
      type: Array,
      default: () => []
    }
  }
}
</script>
