<template>
  <the-terms />
</template>

<script>
import theTerms from "../components/TheTerms"

export default {
  components: {
    theTerms
  },
  mounted() {
    this.$toTop()
    document.title = "利用規約 - Hashlog"
  }
}
</script>
