<template>
  <v-footer app absolute>
    <v-spacer />
    <div>利用規約・プライバシーポリシー | 連絡先</div>
    <small>&copy; {{ startYear }} - {{ thisYear }} Hashlog</small>
  </v-footer>
</template>

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
