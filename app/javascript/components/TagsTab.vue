<template>
  <v-tabs>
    <v-tab
      v-for="registeredTag in registeredTags"
      :key="registeredTag.id"
      :to="{ name: 'mypageTag', params: { id: registeredTag.id } }"
    >{{ registeredTag.tag.name }}</v-tab>
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
