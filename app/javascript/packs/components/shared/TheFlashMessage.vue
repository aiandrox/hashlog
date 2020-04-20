<template>
  <v-alert text dismissible type="success">{{ message }}</v-alert>
</template>

<script>
export default {
  data() {
    return {
      message: "flash message"
    }
  }
}
</script>
