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
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    },
    // ページネーション。ボタンを押したときに表示するデータを変更する
    async changePage(val) {
      goTo(0)
      const res = await this.$axios.get(`${this.page.requestUrl}?page=${val}`)
      // TODO: 増えたらメソッドに切り出す
      const { tweets } = res.data
      this.tweets = tweets
    }
  }
}
