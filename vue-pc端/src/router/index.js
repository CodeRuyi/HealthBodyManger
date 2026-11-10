import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import UserView from '../views/UserView.vue'
import DietitianView from '../views/DietitianView.vue'
import KnowledgeBaseView from '../views/KnowledgeBaseView.vue'
import PermissionView from '../views/PermissionView.vue'
import MemberView from '../views/MemberView.vue'
import LoginView from '../views/LoginView.vue'
import RegisterView from '../views/RegisterView.vue'
import HomePageView from '../views/HomePageView.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/login',
      component:LoginView,
    },
    {
      path: '/register',
      component:RegisterView,
    },
    {
      path: '/home',
      component: HomeView, // 这是你的左侧导航+右侧内容布局
      children: [
        {
          path: '', // 默认子路由，访问 /home 时显示
          component: HomePageView
        },
        {
          path: '/user',
          component: UserView
        },
        {
          path: '/dietitian',
          component: DietitianView
        },
        {
          path: '/knowledge',
          component: KnowledgeBaseView
        },
        {
          path: '/permission',
          component: PermissionView
        },
        {
          path: '/member',
          component: MemberView
        }
      ]
    }
  ]
})

export default router
