import { reactive } from 'vue'

// 全局轻量提示状态（替代原生 alert）
export const toastState = reactive({ items: [] })
let _id = 0

export function useToast() {
  const show = (message, type = 'info', duration = 2600) => {
    const id = ++_id
    toastState.items.push({ id, message, type })
    setTimeout(() => {
      const i = toastState.items.findIndex(x => x.id === id)
      if (i !== -1) toastState.items.splice(i, 1)
    }, duration)
  }
  return { show }
}
