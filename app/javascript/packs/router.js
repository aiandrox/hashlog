import VueRouter from "vue-router"

import store from "../store"
import Top from "../pages/Top"
import Mypage from "../pages/Mypage"
import MyTag from "../pages/MyTag"
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
    component: Mypage,
    meta: { requiredLogin: true }
  },
  {
    path: "/mypage/tags/:tagId",
    name: "myTag",
    component: MyTag
  },
  {
    path: "/users/:userUuid",
    name: "user",
    component: User
  },
  {
    path: "/users/:user_uuid/tags/:id",
    name: "userTag"
    // component: UserTag
  }
]

const router = new VueRouter({ mode: "history", routes })

router.beforeEach((to, from, next) => {
  store.dispatch("user/getCurrentUser").then(currentUser => {
    if (to.matched.some(record => record.meta.requiredLogin) && !currentUser) {
      // next({ name: "Top" })
    }
    next()
  })
})

export default router
