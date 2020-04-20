import VueRouter from 'vue-router'

import Top from './pages/Top.vue'
import Mypage from './pages/Mypage.vue'
import Tweets from './components/RegisteredTagsTweets.vue'

const routes = [
  {
    path: '/',
    name: 'top',
    component: Top,
  },
  {
    path: '/mypage',
    name: 'mypage',
    component: Mypage,
    children: [
      {
        path: 'tags/:id',
        name: 'mypage_registered_tags',
        component: Tweets,
      },
    ],
  },
]

export default new VueRouter({mode: 'history', routes})
