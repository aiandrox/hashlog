import goTo from "vuetify/es5/services/goto"

export default {
  methods: {
    // ページネーション。ページ用コンポーネントでpageオブジェクトを定義しておくこと。
    $setPaginationData(response) {
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    },
    // ページネーション。ボタンを押したときに表示するデータを変更する
    async $changePaginationPage(val) {
      goTo(0)
      const res = await this.$axios.get(`${this.page.requestUrl}?page=${val}`)
      // TODO: 増えたらメソッドに切り出す
      const { tweets } = res.data
      this.tweets = tweets
    }
  }
}
