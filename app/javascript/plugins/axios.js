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
  switch (error.response.status) {
    case 401:
      return "ログインしてください"
    case 403:
      return "アクセスが許可されていません"
    case 404:
      return "リソースが見つかりません"
    case 422: // バリデーションメッセージは個別で処理を行う
      console.log("入力データが不適です")
      return null
    case 429:
      console.log("TwitterAPI制限です")
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
