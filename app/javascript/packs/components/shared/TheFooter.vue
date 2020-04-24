<template>
  <v-footer app absolute>
    <v-spacer />
    <div>&copy; {{ startYear }} - {{ thisYear }} Hashlog</div>
  </v-footer>
</template>

<style scoped></style>

<script>
export default {
  data() {
    return {
      startYear: 2020
    }
  },
  computed: {
    thisYear() {
      return new Date().getFullYear()
    }
  }
}
</script>
