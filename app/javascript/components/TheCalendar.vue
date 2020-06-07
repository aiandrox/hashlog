<template>
  <v-container class="main-content">
    <v-date-picker
      v-model="date"
      full-width
      no-title
      color="primary"
      event-color="green"
      :landscape="$vuetify.breakpoint.smAndUp"
      :events="tweetedDates"
      class="mt-4"
    ></v-date-picker>
  </v-container>
</template>

<script>
export default {
  props: {
    tweets: {
      type: Array,
      default: () => [],
      required: true
    }
  },
  data() {
    return {
      date: new Date().toISOString().substr(0, 10)
    }
  },
  computed: {
    tweetedDates() {
      return this.tweets.map(t => t.tweetedAt.substr(0, 10))
    }
  }
}
</script>
