import VueRouter from "vue-router";

import Top from "./pages/top.vue";
import Mypage from "./pages/mypage.vue";
import Tweets from "./components/tweets.vue";

const routes = [
  {
    path: "/",
    name: "top",
    component: Top,
  },
  {
    path: "/mypage",
    name: "mypage",
    component: Mypage,
    children: [
      {
        path: "tags/:id",
        name: "mypage_registerd_tags",
        component: Tweets,
      },
    ],
  },
];

export default new VueRouter({ mode: "history", routes });
