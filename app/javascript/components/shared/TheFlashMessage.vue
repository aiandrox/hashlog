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
  max-width: 350px;
  z-index: 100;
  /* z-index:は、フッターが3, オーバーレイが200 */
}
.v-alert--outlined {
  background: rgba(255, 255, 255, 0.9) !important;
}
.v-alert {
  font-size: 14px;
}
</style>
