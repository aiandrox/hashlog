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
  const errorJson = error.response.data.error
  if (errorJson) {
    return errorJson.messages[0]
  }
  return "予期せぬエラーが発生しました"
}

http.interceptors.response.use(
  response => response,
  error => {
    const { status } = error.response
    if (status === 404) {
      store.dispatch("isNotFound/setIsNotFound", {
        boolean: true
      })
    } else {
      store.dispatch("flash/setFlash", {
        type: "error",
        message: errorMessage(error)
      })
    }
    return Promise.reject(error)
  }
)

export default http
