<template>
  <div class="home">
    <!-- 左侧导航栏 -->
    <aside class="nav">
      <div class="nav-header">
        <span class="logo"><Icon name="shield" :size="18" /></span>
        <span class="title">防暴食管理系统</span>
      </div>

      <nav class="nav-menu">
        <div
          v-for="item in menus"
          :key="item.path"
          class="nav-item"
          :class="{ active: currentPath === item.path }"
          @click="router.push(item.path)"
        >
          <Icon :name="item.icon" :size="18" />
          <span class="label">{{ item.label }}</span>
        </div>
      </nav>

      <div class="nav-footer">
        <div class="user-info">
          <img
            src="https://api.dicebear.com/7.x/avataaars/svg?seed=Admin"
            alt="Admin"
            class="avatar"
          />
          <div class="meta">
            <div class="name">{{ userName || 'Admin_PC' }}</div>
            <div class="date">{{ today }}</div>
          </div>
        </div>
        <button class="logout" @click="handleLogout">
          <Icon name="logout" :size="16" />
          <span>退出登录</span>
        </button>
      </div>
    </aside>

    <!-- 右侧内容区 -->
    <main class="content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const route = useRoute()
const router = useRouter()
const { show } = useToast()

// 导航菜单（图标统一来源 Icon 组件）
const menus = [
  { path: '/home', label: '首页', icon: 'home' },
  { path: '/user', label: '用户管理', icon: 'users' },
  { path: '/dietitian', label: '营养师', icon: 'doctor' },
  { path: '/knowledge', label: '科普知识库', icon: 'book' },
  { path: '/permission', label: '权限管理', icon: 'lock' },
  { path: '/member', label: '会员管理', icon: 'diamond' }
]

const currentPath = computed(() => route.path)

// 管理员信息（来自登录态）
const userName = ref(localStorage.getItem('userName') || '')

// 动态日期
const today = new Date().toLocaleDateString('zh-CN', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  weekday: 'short'
})

const handleLogout = () => {
  localStorage.removeItem('userId')
  localStorage.removeItem('userName')
  show('已退出登录', 'success')
  router.push('/login')
}
</script>

<style lang="less" scoped>
.home {
  display: flex;
  width: 100vw;
  height: 100vh;
  background: var(--bg-base);
  overflow: hidden;
}

.nav {
  width: 220px;
  flex-shrink: 0;
  background: var(--bg-surface-2);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
}

.nav-header {
  display: flex;
  align-items: center;
  gap: 10px;
  height: 64px;
  padding: 0 20px;
  border-bottom: 1px solid var(--border);
  font-size: 15px;
  font-weight: 600;
  color: var(--text-1);

  .logo {
    width: 30px;
    height: 30px;
    background: var(--primary);
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
  }
}

.nav-menu {
  flex: 1;
  padding: 12px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  height: 44px;
  padding: 0 14px;
  border-radius: var(--radius-sm);
  color: var(--text-3);
  font-size: 14px;
  cursor: pointer;
  transition: var(--transition);
  border-left: 3px solid transparent;

  &:hover {
    background: var(--bg-elevated);
    color: var(--text-1);
  }

  &.active {
    background: var(--primary-soft);
    color: var(--primary);
    border-left-color: var(--primary);
    font-weight: 500;
  }
}

.nav-footer {
  padding: 14px 16px;
  border-top: 1px solid var(--border);

  .user-info {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;

    .avatar {
      width: 34px;
      height: 34px;
      border-radius: 50%;
      background: var(--bg-elevated);
      object-fit: cover;
    }
    .meta .name {
      color: var(--text-1);
      font-size: 13px;
      font-weight: 500;
    }
    .meta .date {
      font-size: 11px;
      color: var(--text-4);
    }
  }

  .logout {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    width: 100%;
    height: 34px;
    background: transparent;
    border: 1px solid var(--border-strong);
    border-radius: var(--radius-sm);
    color: var(--text-3);
    font-size: 13px;
    cursor: pointer;
    transition: var(--transition);

    &:hover {
      border-color: var(--primary);
      color: var(--primary);
    }
  }
}

.content {
  flex: 1;
  background: var(--bg-base);
  padding: 20px 24px;
  overflow-y: auto;
}
</style>
