<template>
  <v-tabs>
    <v-tab
      v-for="registeredTag in registeredTags"
      :key="registeredTag.name"
      :to="{ name: 'tag', params: { id: registeredTag.id } }"
    >{{ registeredTag.name }}</v-tab>
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
