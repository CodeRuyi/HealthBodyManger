<template>
  <div class="register-page">
    <div class="register-box">
      <div class="register-title">
        <div class="logo-box"><Icon name="shield" :size="24" /></div>
        <h1>注册管理员</h1>
        <p>创建新的后台管理账号</p>
      </div>

      <div class="form-group">
        <label>用户名</label>
        <input type="text" placeholder="请输入用户名" v-model="username" />
      </div>

      <div class="form-group">
        <label>密码</label>
        <input type="password" placeholder="请输入密码" v-model="password" />
      </div>

      <div class="form-group">
        <label>确认密码</label>
        <input type="password" placeholder="请再次输入密码" v-model="confirmPwd" @keyup.enter="handleRegister" />
      </div>

      <button class="register-btn" @click="handleRegister">注册</button>

      <div class="link-text">
        已有账号？<router-link to="/login" class="link-login">立即登录</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { register } from '@/api/request'
import { useRouter } from 'vue-router'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const username = ref('')
const password = ref('')
const confirmPwd = ref('')
const router = useRouter()
const { show } = useToast()

const handleRegister = async () => {
  if (!username.value || !password.value || !confirmPwd.value) {
    show('请填写完整注册信息', 'warning')
    return
  }
  if (password.value !== confirmPwd.value) {
    show('两次密码不一致', 'warning')
    return
  }
  try {
    const res = await register({ username: username.value, password: password.value })
    if (res.data.code === 200) {
      show('注册成功，请登录', 'success')
      router.push('/login')
    } else {
      show(res.data.message || '注册失败', 'error')
    }
  } catch (e) {
    show('网络异常，请稍后重试', 'error')
  }
}
</script>

<style scoped lang="less">
.register-page {
  width: 100vw;
  height: 100vh;
  background: radial-gradient(1200px 600px at 70% -10%, #1c1c1c 0%, var(--bg-base) 60%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.register-box {
  width: 400px;
  padding: 40px 40px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow);
}

.register-title {
  text-align: center;
  margin-bottom: 30px;
  .logo-box {
    width: 46px;
    height: 46px;
    margin: 0 auto 12px;
    background: var(--primary);
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
  }
  h1 {
    font-size: 22px;
    color: var(--text-1);
    margin-bottom: 6px;
  }
  p {
    font-size: 13px;
    color: var(--text-3);
  }
}

.form-group {
  margin-bottom: 20px;
  label {
    display: block;
    color: var(--text-3);
    font-size: 13px;
    margin-bottom: 8px;
  }
  input {
    width: 100%;
    height: 46px;
    padding: 0 14px;
    background: var(--bg-input);
    border: 1px solid var(--border-strong);
    border-radius: var(--radius-sm);
    color: var(--text-1);
    outline: none;
    font-size: 14px;
    transition: var(--transition);
    &:focus { border-color: var(--primary); background: var(--bg-elevated); }
  }
}

.register-btn {
  width: 100%;
  height: 46px;
  background: var(--primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 15px;
  cursor: pointer;
  margin-top: 8px;
  transition: var(--transition);
  &:hover { background: var(--primary-hover); }
}

.link-text {
  text-align: center;
  margin-top: 18px;
  font-size: 13px;
  color: var(--text-3);
  .link-login {
    color: var(--primary);
    &:hover { text-decoration: underline; }
  }
}
</style>
