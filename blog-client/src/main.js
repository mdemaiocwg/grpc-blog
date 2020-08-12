import Vue from "vue";
import App from "./App.vue";
import CustomFooter from './components/CustomFooter.vue';
import AddForm from './components/AddForm.vue';

Vue.config.productionTip = false;

Vue.component('custom-footer', CustomFooter);
Vue.component('add-form', AddForm);

new Vue({
  render: h => h(App)
}).$mount("#app");
