import goTo from "vuetify/es5/services/goto"

export default {
  methods: {
    $toTop() {
      const pageTop = 0
      goTo(pageTop)
    }
  }
}
