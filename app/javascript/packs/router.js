import VueRouter from "vue-router"

import Top from "../pages/Top.vue"
import Mypage from "../pages/Mypage.vue"
import Tag from "../pages/Tag.vue"

const routes = [
  {
    path: "/",
    name: "top",
    component: Top
  },
  {
    path: "/mypage",
    name: "mypage",
    component: Mypage
  },
  {
    path: "/mypage/tags/:id",
    name: "tag",
    component: Tag
  }
]

export default new VueRouter({ mode: "history", routes })
