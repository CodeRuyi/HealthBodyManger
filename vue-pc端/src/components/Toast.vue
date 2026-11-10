<template>
  <div class="toast-wrap">
    <transition-group name="toast">
      <div v-for="t in toastState.items" :key="t.id" class="toast" :class="t.type">
        <span class="toast-dot"></span>
        <span class="toast-msg">{{ t.message }}</span>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import { toastState } from '@/composables/useToast'
</script>

<style scoped>
.toast-wrap {
  position: fixed;
  top: 24px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  pointer-events: none;
}
.toast {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  background: var(--bg-surface);
  border: 1px solid var(--border-strong);
  border-radius: var(--radius-pill);
  color: var(--text-1);
  font-size: 13px;
  box-shadow: var(--shadow);
}
.toast-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--text-3);
}
.toast.success .toast-dot { background: var(--success); }
.toast.warning .toast-dot { background: var(--warning); }
.toast.error .toast-dot   { background: var(--danger); }

.toast-enter-active,
.toast-leave-active {
  transition: all 0.28s ease;
}
.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
