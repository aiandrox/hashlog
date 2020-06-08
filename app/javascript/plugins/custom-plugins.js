import goTo from "vuetify/es5/services/goto"

export default {
  methods: {
    $toTop() {
      goTo(0)
    }
  }
}
