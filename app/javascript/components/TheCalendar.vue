<template>
  <v-container class="main-content">
    <v-date-picker
      ref="picker"
      v-model="date"
      full-width
      no-title
      color="primary"
      event-color="pink"
      :weekday-format="weekdayFormat"
      :allowed-dates="allowedDates"
      :events="tweetDates"
      @input="inputDate"
      class="mt-4"
    ></v-date-picker>
  </v-container>
</template>

<script>
import dayjs from "dayjs"

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
    allowedDates(val) {
      return this.tweetDates.includes(val)
    },
    weekdayFormat(val) {
      return dayjs(val).format("dd")
    },
    inputDate(date) {
      this.$emit("input-date", date)
    }
  },
  watch: {
    $route() {
      this.date = ""
      this.$refs.picker.activePicker = "DATE"
    }
  }
}
</script>
