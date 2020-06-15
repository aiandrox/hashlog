import Axios from "axios"
import store from "../store/index"

const http = Axios.create({
  // for cors
  withCredentials: true
})

http.interceptors.request.use(request => {
  const csrfToken = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content")
  request.headers.common = {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": csrfToken
  }
  return request
})

const errorMessage = error => {
  const unauthorized = 402
  const forbidden = 403
  const notFound = 404
  const unprocessableEntity = 422
  const tooManyRequests = 429
  switch (error.response.status) {
    case unauthorized:
      return "ログインしてください"
    case forbidden:
      return "アクセスが許可されていません"
    case notFound:
      return "リソースが見つかりません"
    case unprocessableEntity: // バリデーションメッセージは個別で処理を行う
      return null
    case tooManyRequests: // フォームにエラーメッセージを表示する（同上）
      return null
    default:
      return "予期せぬエラーが発生しました"
  }
}

http.interceptors.response.use(
  response => response,
  error => {
    store.dispatch("flash/setFlash", {
      type: "error",
      message: errorMessage(error)
    })
    return Promise.reject(error)
  }
)

export default http
