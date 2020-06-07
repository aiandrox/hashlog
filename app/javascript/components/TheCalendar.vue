<template>
  <v-container class="main-content">
    <v-date-picker
      v-model="date"
      full-width
      no-title
      color="primary"
      event-color="green"
      :landscape="$vuetify.breakpoint.smAndUp"
      :events="tweetDates"
      @input="inputDate"
      class="mt-4"
    ></v-date-picker>
    {{ date }}
  </v-container>
</template>

<script>
export default {
  props: {
    tweetDates: {
      type: Array,
      default: () => [],
      required: true
    }
  },
  data() {
    return {
      date: ""
    }
  },
  methods: {
    inputDate(date) {
      this.$emit("input-date", date)
    }
  },
  watch: {
    $route() {
      this.date = ""
    }
  }
}
</script>
