/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import App from "../app.vue";
import Vue from "vue";

import VueRouter from "vue-router";
import router from "./router";
Vue.use(VueRouter);

import Vuex from "vuex";
// import store from './store1.js'
Vue.use(Vuex);

import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import "@mdi/font/css/materialdesignicons.css";
Vue.use(Vuetify);
Vue.config.productionTip = false;
const vuetify = new Vuetify({
  icons: {
    iconfont: "mdi", // default - only for display purposes
  },
});

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#app",
    router,
    vuetify,
    // store: store,
    render: (h) => h(App),
  });
});
