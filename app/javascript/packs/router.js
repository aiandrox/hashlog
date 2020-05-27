import VueRouter from "vue-router"

import Top from "../pages/Top"
import Mypage from "../pages/Mypage"
import Tag from "../pages/Tag"
import User from "../pages/User"

const routes = [
  {
    path: "/",
    name: "top",
    component: Top
  },
  {
    path: "/mypage/dashboard",
    name: "mypage",
    component: Mypage
  },
  {
    path: "/mypage/tags/:tag_id",
    name: "mypageTag",
    component: Tag
  },
  {
    path: "/users/:user_uuid",
    name: "user",
    component: User
  },
  {
    path: "/users/:user_uuid/tags/:id",
    name: "userTag",
    component: Tag
  }
]

export default new VueRouter({ mode: "history", routes })
