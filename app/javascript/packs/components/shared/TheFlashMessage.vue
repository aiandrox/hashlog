<template>
  <v-alert
    text
    dismissible
    type="success"
  >
    {{ this.message }}
  </v-alert>
</template>

<script>
export default {
  data() {
    return {
      message: "flash message",
    }
  },
}
</script>
