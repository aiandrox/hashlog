import goTo from "vuetify/es5/services/goto"

export default {
  mounted() {
    // ページタイトル。動的なページタイトルはコンポーネントで定義すること
    let { title } = this.$options
    if (title) {
      title = typeof title === "function" ? title.call(this) : title
      document.title = `${title} | Hashlog`
    }
  },
  methods: {
    // ページネーション。ページ用コンポーネントでpageオブジェクトを定義しておくこと。
    setPageData(response) {
      this.page.currentPage = Number(response.headers["current-page"])
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    }
  },
  watch: {
    // ページネーション。ボタンを押したときに表示するデータを変更する
    async "page.currentPage"(val) {
      goTo(0)
      const res = await this.$axios.get(`${this.page.requestUrl}?page=${val}`)
      // 増えたらメソッドに切り出す
      const { tweets } = res.data
      this.tweets = tweets
    }
  }
}
