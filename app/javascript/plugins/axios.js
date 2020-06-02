import Axios from "axios"

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

http.interceptors.response.use(
  response => response,
  error => {
    switch (error.response.status) {
      case 401:
        console.log(error.response.data.error.detail)
        break
      case 403:
        console.log("アクセスが許可されていません")
        break
      case 404:
        console.log("リソースが見つかりません")
        break
      case 422: // バリデーションメッセージは個別で処理を行う
        console.log("入力データが不適です")
        break
      default:
        console.log("エラーが発生しました")
    }
    return Promise.reject(error)
  }
)

export default http
