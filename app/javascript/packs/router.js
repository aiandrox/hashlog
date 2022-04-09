import VueRouter from "vue-router"

import store from "../store"
import Top from "../pages/TheTop"
import TagRanking from "../pages/TagRanking"
import Terms from "../pages/TheTerms"
import PrivacyPolicy from "../pages/PrivacyPolicy"
import Mypage from "../pages/TheMypage"
import MyTag from "../pages/MyTag"
import User from "../pages/TheUser"
import UserTag from "../pages/UserTag"
import NotFound from "../pages/NotFound"

const routes = [
  {
    path: "/",
    name: "top",
    component: Top
  },
  {
    path: "/terms",
    name: "terms",
    component: Terms
  },
  {
    path: "/privacy_policy",
    name: "privacyPolicy",
    component: PrivacyPolicy
  },
  {
    path: "/ranking/:type",
    name: "tagRanking",
    component: TagRanking
  },
  {
    path: "/mypage/dashboard",
    name: "mypage",
    component: Mypage,
    meta: { requiredLogin: true, title: "マイページ" }
  },
  {
    path: "/mypage/tags/:tagId",
    name: "myTag",
    component: MyTag,
    meta: { requiredLogin: true }
  },
  {
    path: "/users/:userUuid",
    name: "user",
    component: User
  },
  {
    path: "/users/:userUuid/tags/:tagId",
    name: "userTag",
    component: UserTag
  },
  {
    path: "*",
    name: "notFound",
    component: NotFound,
    meta: { title: "ページが見つかりません" }
  }
]

const router = new VueRouter({ mode: "history", routes })

router.beforeEach((to, _from, next) => {
  store.dispatch("user/getCurrentUser").then(currentUser => {
    if (to.matched.some(record => record.meta.requiredLogin) && !currentUser) {
      store.dispatch("flash/setFlash", {
        type: "error",
        message: "ログインしてください"
      })
      return next({ name: "top" })
    }
    return next()
  })
})

export default router
