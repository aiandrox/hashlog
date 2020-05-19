import goTo from "vuetify/es5/services/goto"

export default {
  mounted() {
    let { title } = this.$options
    if (title) {
      title = typeof title === "function" ? title.call(this) : title
      document.title = `${title} | Hashlog`
    }
  },
  methods: {
    setPageData(response) {
      this.page.currentPage = Number(response.headers["current-page"])
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    }
  },
  watch: {
    async "page.currentPage"(val) {
      goTo(0)
      const res = await this.$axios.get(`${this.page.requestUrl}?page=${val}`)
      const { tweets } = res.data
      this.tweets = tweets
    }
  }
}
