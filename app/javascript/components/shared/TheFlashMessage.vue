<template>
  <v-fade-transition>
    <div class="flash">
      <v-alert dense outlined :type="flash.type">{{ flash.message }}</v-alert>
    </div>
  </v-fade-transition>
</template>

<script>
import { mapGetters } from "vuex"

export default {
  data() {
    return {
      isShow: true
    }
  },
  computed: {
    ...mapGetters({ flash: "flash/flash" })
  },
  mounted() {
    setTimeout(() => {
      this.$store.dispatch("flash/setFlash", {
        type: "",
        message: ""
      })
    }, 3000)
  }
}
</script>

<style scoped>
.flash {
  position: fixed;
  bottom: 10px;
  left: 20px;
  z-index: 5;
  max-width: 350px;
  /* フッターがz-index: 3なので */
}
.v-alert--outlined {
  background: rgba(255, 255, 255, 0.9) !important;
}
.v-alert {
  font-size: 14px;
}
</style>
