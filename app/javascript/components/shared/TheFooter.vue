<template>
  <v-footer app absolute dark color="primary">
    <v-spacer />
    <div>
      <v-btn dense text @click="push('terms')">利用規約</v-btn>
      <v-btn dense text @click="push('privacyPolicy')"
        >プライバシーポリシー</v-btn
      >
      <v-btn icon href="https://twitter.com/Hash1og">
        <v-icon>mdi-twitter</v-icon>
      </v-btn>
    </div>
    <small>&copy; {{ copyText }}</small>
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
    },
    copyText() {
      if (this.startYear === this.thisYear) {
        return `${this.thisYear} Hashlog`
      }
      return `${this.startYear} - ${this.thisYear} Hashlog`
    }
  },
  methods: {
    push(routerName) {
      this.$router.push({ name: routerName })
    }
  }
}
</script>

<style lang="scss" scoped>
small {
  margin-left: 20px;
}
.v-btn:not(.v-btn--round).v-size--default {
  padding: 0 5px;
}
</style>
