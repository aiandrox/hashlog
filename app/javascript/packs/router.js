import VueRouter from 'vue-router'

import Top from './pages/top.vue'
import Mypage from './pages/mypage.vue'

const routes = [
  {
    path: '/',
    name: 'top',
    component: Top
  }, {
    path: '/mypage',
    name: 'mypage',
    component: Mypage
  }
];

export default new VueRouter({ routes });
