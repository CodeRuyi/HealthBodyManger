<template>
  <!-- 统一线性图标，stroke 继承当前文字颜色，替代 emoji，更正式
       如需切换到 iconfont：删除此组件，改用 <svg class="iconfont"><use href="#icon-xxx"/></svg> 即可 -->
  <svg
    class="ui-icon"
    :width="size"
    :height="size"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    :stroke-width="strokeWidth"
    stroke-linecap="round"
    stroke-linejoin="round"
    aria-hidden="true"
  >
    <path v-for="(d, i) in paths" :key="i" :d="d" />
  </svg>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  name: { type: String, required: true },
  size: { type: [Number, String], default: 18 },
  strokeWidth: { type: [Number, String], default: 2 }
})

// 图标路径表（24x24 线性风格）
const ICONS = {
  // 导航 / 模块
  home: ['M3 11l9-8 9 8', 'M5 10v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V10'],
  users: ['M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2', 'M9 7a4 4 0 1 0 0-8 4 4 0 0 0 0 8z', 'M23 21v-2a4 4 0 0 0-3-3.87', 'M16 3.13a4 4 0 0 1 0 7.75'],
  doctor: ['M4 3v6a5 5 0 0 0 10 0V3', 'M4 3H2m2 0h2', 'M14 3h-2m2 0h2', 'M9 19a3 3 0 0 0 6 0v-3', 'M12 16v-3'],
  book: ['M4 19.5A2.5 2.5 0 0 1 6.5 17H20', 'M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z'],
  lock: ['M5 11h14a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2z', 'M8 11V7a4 4 0 0 1 8 0v4'],
  diamond: ['M6 3h12l4 6-10 12L2 9z'],
  dashboard: ['M3 3h8v8H3z', 'M13 3h8v5h-8z', 'M13 11h8v10h-8z', 'M3 13h8v8H3z'],

  // 通用操作
  search: ['M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16z', 'M21 21l-4.3-4.3'],
  bell: ['M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9', 'M13.7 21a2 2 0 0 1-3.4 0'],
  refresh: ['M21 2v6h-6', 'M3 12a9 9 0 0 1 15-6.7L21 8', 'M3 22v-6h6', 'M21 12a9 9 0 0 1-15 6.7L3 16'],
  pencil: ['M12 20h9', 'M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4z'],
  trash: ['M3 6h18', 'M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2', 'M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6'],
  more: ['M6 12a1 1 0 1 0 0-2 1 1 0 0 0 0 2z', 'M12 12a1 1 0 1 0 0-2 1 1 0 0 0 0 2z', 'M18 12a1 1 0 1 0 0-2 1 1 0 0 0 0 2z'],
  plus: ['M12 5v14', 'M5 12h14'],
  eye: ['M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z', 'M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'],
  close: ['M18 6L6 18', 'M6 6l12 12'],
  calendar: ['M3 4h18v18H3z', 'M3 10h18', 'M8 2v4', 'M16 2v4'],
  download: ['M12 3v12', 'M7 10l5 5 5-5', 'M5 21h14'],
  check: ['M20 6L9 17l-5-5'],
  checkCircle: ['M22 11.08V12a10 10 0 1 1-5.93-9.14', 'M22 4L12 14.01l-3-3'],
  monitor: ['M22 12h-4l-3 9L9 3l-3 9H2'],
  logout: ['M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4', 'M16 17l5-5-5-5', 'M21 12H9'],
  shield: ['M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z'],
  clock: ['M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20z', 'M12 6v6l4 2'],
  filter: ['M22 3H2l8 9.46V19l4 2v-8.54z'],
  flag: ['M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z', 'M4 22V4'],
  chevronLeft: ['M15 18l-6-6 6-6'],
  chevronRight: ['M9 18l6-6-6-6'],

  // 业务相关
  fire: ['M12 2s4 4 4 8a4 4 0 0 1-8 0c0-1 .5-2 1-3-2 1-3 3-3 5a6 6 0 0 0 12 0c0-4-6-10-6-10z'],
  comment: ['M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z'],
  star: ['M12 2l3 7 7 .5-5.5 4.5 2 7-6.5-4-6.5 4 2-7L2 9.5 9 9z'],
  money: ['M12 1v22', 'M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6'],
  trendingUp: ['M23 6l-9.5 9.5-5-5L1 18', 'M17 6h6v6'],
  userCheck: ['M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2', 'M9 7a4 4 0 1 0 0-8 4 4 0 0 0 0 8z', 'M16 11l2 2 4-4']
}

const paths = computed(() => ICONS[props.name] || [])
</script>

<style scoped>
.ui-icon {
  display: inline-block;
  vertical-align: middle;
  flex-shrink: 0;
}
</style>
