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
    document.title = "利用規約 - Hashlog"
  }
}
</script>
