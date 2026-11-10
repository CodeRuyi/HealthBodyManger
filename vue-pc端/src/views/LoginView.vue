<template>
  <div class="login-page">
    <div class="login-box">
      <!-- 系统 logo 与标题 -->
      <div class="system-header">
        <div class="logo-box">
          <Icon name="shield" :size="26" />
        </div>
        <div class="system-name">
          <h2>防暴食管理系统</h2>
          <p>Anti-Binge Management</p>
        </div>
      </div>

      <div class="login-title">
        <h1>登录管理后台</h1>
        <p>请使用管理员账号登录以继续操作</p>
      </div>

      <!-- 错误提示 -->
      <div v-if="errorMsg" class="error-tip">
        <Icon name="close" :size="16" />
        <span>{{ errorMsg }}</span>
      </div>

      <!-- 表单 -->
      <div class="form-group">
        <label>用户名</label>
        <input
          type="text"
          placeholder="请输入用户名"
          v-model="username"
          :class="{ 'error-input': errorMsg }"
        />
      </div>

      <div class="form-group">
        <label>密码</label>
        <input
          type="password"
          placeholder="请输入密码"
          v-model="password"
          :class="{ 'error-input': errorMsg }"
          @keyup.enter="handleLogin"
        />
      </div>

      <button class="login-btn" @click="handleLogin">登录</button>

      <div class="default-account">
        <p>默认账号：<span>admin</span> / 密码：<span>admin123</span></p>
        <p>其他账号请联系系统管理员</p>
      </div>

      <div class="register-link">
        没有账号？<router-link to="/register" class="link-register">立即注册</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { login } from '@/api/request'
import { useRouter } from 'vue-router'
import Icon from '@/components/Icon.vue'

const username = ref('')
const password = ref('')
const errorMsg = ref('')
const router = useRouter()

const handleLogin = async () => {
  errorMsg.value = ''
  if (!username.value || !password.value) {
    errorMsg.value = '用户名和密码不能为空'
    return
  }

  try {
    const res = await login(username.value, password.value)
    if (res.data.code === 400) {
      errorMsg.value = '用户名或密码错误'
      return
    }
    if (res.data.code === 200) {
      localStorage.setItem('userId', res.data.data.id)
      localStorage.setItem('userName', res.data.data.username)
      router.push('/home')
    }
  } catch (e) {
    errorMsg.value = '网络异常，请稍后重试'
  }
}
</script>

<style scoped lang="less">
.login-page {
  width: 100vw;
  height: 100vh;
  background: radial-gradient(1200px 600px at 70% -10%, #1c1c1c 0%, var(--bg-base) 60%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-box {
  width: 420px;
  padding: 40px 44px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow);
}

.system-header {
  display: flex;
  align-items: center;
  margin-bottom: 28px;

  .logo-box {
    width: 48px;
    height: 48px;
    background: var(--primary);
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    margin-right: 12px;
  }

  .system-name h2 {
    color: var(--text-1);
    font-size: 20px;
    font-weight: 600;
    margin: 0 0 4px;
  }
  .system-name p {
    color: var(--text-4);
    font-size: 13px;
    margin: 0;
  }
}

.login-title {
  margin-bottom: 22px;
  h1 {
    font-size: 30px;
    color: var(--text-1);
    margin: 0 0 8px;
    font-weight: 600;
  }
  p {
    font-size: 14px;
    color: var(--text-3);
    margin: 0;
  }
}

.error-tip {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255, 59, 48, 0.1);
  border: 1px solid rgba(255, 59, 48, 0.4);
  border-radius: var(--radius-sm);
  color: #ff6b61;
  padding: 10px 14px;
  margin-bottom: 18px;
  font-size: 13px;
}

.form-group {
  margin-bottom: 18px;
  label {
    display: block;
    color: var(--text-3);
    font-size: 13px;
    margin-bottom: 8px;
  }
  input {
    width: 100%;
    height: 48px;
    padding: 0 14px;
    background: var(--bg-input);
    border: 1px solid var(--border-strong);
    border-radius: var(--radius-sm);
    color: var(--text-1);
    outline: none;
    font-size: 14px;
    transition: var(--transition);
    &::placeholder { color: var(--text-4); }
    &:focus {
      border-color: var(--primary);
      background: var(--bg-elevated);
    }
  }
  .error-input {
    background: rgba(255, 59, 48, 0.08);
    border-color: var(--danger);
    color: var(--text-1);
  }
}

.login-btn {
  width: 100%;
  height: 48px;
  background: var(--primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 16px;
  cursor: pointer;
  margin: 6px 0 20px;
  font-weight: 500;
  transition: var(--transition);
  &:hover { background: var(--primary-hover); }
}

.default-account {
  font-size: 13px;
  color: var(--text-4);
  padding-top: 20px;
  border-top: 1px solid var(--border);
  p { margin: 5px 0; }
  span { color: var(--text-2); font-weight: 500; }
}

.register-link {
  text-align: center;
  font-size: 13px;
  color: var(--text-3);
  margin-top: 16px;
  .link-register {
    color: var(--primary);
    margin-left: 4px;
    &:hover { text-decoration: underline; }
  }
}
</style>
