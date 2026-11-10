<template>
  <div class="dashboard">
    <!-- 顶部栏 -->
    <header class="top-bar">
      <div class="crumb">
        管理端后台 <span class="sep">/</span> <span class="current">数据概览</span>
      </div>
      <div class="top-actions">
        <span class="icon-btn"><Icon name="search" :size="18" /></span>
        <span class="icon-btn"><Icon name="bell" :size="18" /></span>
        <span class="monitor-tag" :class="{ active: isMonitoring }">
          <Icon :name="isMonitoring ? 'monitor' : 'monitor'" :size="14" />
          {{ isMonitoring ? '实时监控中' : '监护待命' }}
        </span>
      </div>
    </header>

    <!-- 核心指标卡片 -->
    <section class="stat-cards">
      <div class="stat-card" v-for="s in stats" :key="s.label">
        <div class="stat-icon"><Icon :name="s.icon" :size="20" /></div>
        <div class="stat-body">
          <div class="stat-label">{{ s.label }}</div>
          <div class="stat-value">{{ s.value }}</div>
        </div>
      </div>
    </section>

    <!-- 快捷入口 -->
    <section class="quick-row">
      <div class="card quick-card" v-for="q in quickEntries" :key="q.path" @click="go(q.path)">
        <div class="quick-icon"><Icon :name="q.icon" :size="22" /></div>
        <div class="quick-text">
          <div class="quick-title">{{ q.title }}</div>
          <div class="quick-desc">{{ q.desc }}</div>
        </div>
        <Icon name="more" :size="18" class="quick-arrow" />
      </div>
    </section>

    <!-- 图表区 -->
    <section class="charts-row">
      <!-- 柱状图：真实接口（年龄段统计） -->
      <div class="card chart-card">
        <div class="card-title">核心业务数据统计 · 用户年龄段分布</div>
        <div ref="barChartRef" class="chart-box"></div>
      </div>

      <!-- 折线图：实时异常监控（模拟实时） -->
      <div class="card chart-card">
        <div class="card-title">异常监控频率统计</div>
        <div ref="lineChartRef" class="chart-box"></div>
      </div>

      <!-- 系统负载 -->
      <div class="card chart-card">
        <div class="card-title">系统负载</div>
        <div class="gauge-wrap">
          <div class="gauge" :style="{ '--p': monitorPercent, '--c': isMonitoring ? 'var(--primary)' : 'var(--text-4)' }">
            <span class="gauge-val">{{ monitorPercent }}%</span>
          </div>
          <div class="gauge-label">监护覆盖率</div>
        </div>
        <div class="load-list">
          <div class="load-item" v-for="l in loads" :key="l.label">
            <span class="load-label">{{ l.label }}</span>
            <div class="load-bar"><div class="load-fill" :style="{ width: l.value + '%' }"></div></div>
            <span class="load-num">{{ l.value }}%</span>
          </div>
        </div>
        <button class="btn btn-primary full" @click="toggleMonitor">
          {{ isMonitoring ? '关闭实时监控' : '开启实时监控' }}
        </button>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { getAgeStats } from '@/api/request.js'
import * as echarts from 'echarts'
import Icon from '@/components/Icon.vue'

const router = useRouter()

/* ---------- 状态 ---------- */
const isMonitoring = ref(false)
const monitorPercent = ref(78)

// 顶部指标（概览展示，接入后端后可替换）
const stats = ref([
  { label: '今日营收', value: '¥1,258.6', icon: 'money' },
  { label: '活跃用户', value: '721', icon: 'users' },
  { label: '转化率', value: '89.9%', icon: 'trendingUp' },
  { label: '干预消耗量', value: '59.5g', icon: 'dashboard' },
  { label: '会员总量', value: '499', icon: 'diamond' }
])

// 快捷入口
const quickEntries = [
  { path: '/user', title: '用户管理', desc: '检索 · 干预 · 状态跟踪', icon: 'users' },
  { path: '/permission', title: '权限策略', desc: '角色与节点配置', icon: 'lock' },
  { path: '/member', title: '会员管理', desc: '等级与付费策略', icon: 'diamond' }
]

// 系统负载
const loads = ref([
  { label: 'CPU', value: 70 },
  { label: '内存', value: 45 },
  { label: '数据库', value: 80 }
])

const go = (path) => router.push(path)
const toggleMonitor = () => {
  isMonitoring.value = !isMonitoring.value
  monitorPercent.value = isMonitoring.value ? 92 : 78
}

/* ---------- 图表 ---------- */
const barChartRef = ref(null)
const lineChartRef = ref(null)
let barChart = null
let lineChart = null
let barTimer = null
let lineTimer = null

// 柱状图：对接真实接口
const fetchAgeStats = async () => {
  try {
    const res = await getAgeStats()
    const data = res.data?.data || []
    barChart?.setOption({
      xAxis: { data: data.map(i => i.age_range) },
      series: [{ data: data.map(i => i.count) }]
    })
  } catch (e) {
    console.warn('年龄段统计接口未就绪：', e.message)
  }
}

const initBarChart = () => {
  if (!barChartRef.value) return
  barChart = echarts.init(barChartRef.value)
  barChart.setOption({
    backgroundColor: 'transparent',
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '8%', right: '5%', bottom: '12%', top: '8%' },
    xAxis: { type: 'category', data: [], axisLine: { lineStyle: { color: '#444' } }, axisLabel: { color: '#999' } },
    yAxis: { type: 'value', axisLine: { lineStyle: { color: '#444' } }, splitLine: { lineStyle: { color: '#2a2a2a' } }, axisLabel: { color: '#999' } },
    series: [{
      name: '用户数',
      type: 'bar',
      barWidth: 36,
      itemStyle: {
        borderRadius: [4, 4, 0, 0],
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#ff6b61' },
          { offset: 1, color: '#ff3b30' }
        ])
      },
      label: { show: true, position: 'top', color: '#e0e0e0', fontSize: 13 },
      data: []
    }]
  })
}

// 折线图：实时异常监控（模拟）
const initLineChart = () => {
  if (!lineChartRef.value) return
  lineChart = echarts.init(lineChartRef.value)
  const data = [70, 60, 50, 65, 55, 70, 60, 40, 30, 20, 10]
  lineChart.setOption({
    backgroundColor: 'transparent',
    grid: { left: '8%', right: '5%', top: '12%', bottom: '12%' },
    xAxis: { type: 'category', data: ['0', '2', '4', '6', '8', '10', '12', '14', '16', '18', '20'], axisLine: { lineStyle: { color: '#444' } }, axisLabel: { color: '#999' } },
    yAxis: { type: 'value', axisLine: { lineStyle: { color: '#444' } }, splitLine: { lineStyle: { color: '#2a2a2a' } }, axisLabel: { color: '#999' } },
    series: [{
      type: 'line', smooth: true, symbol: 'none',
      lineStyle: { color: '#ff3b30', width: 2 },
      areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(255,59,48,0.35)' }, { offset: 1, color: 'rgba(255,59,48,0.05)' }]) },
      data
    }]
  })
  // 独立计时器，避免与柱状图刷新互相覆盖
  lineTimer = setInterval(() => {
    const next = data.map(v => Math.max(0, Math.min(100, v + (Math.random() - 0.5) * 12)))
    lineChart.setOption({ series: [{ data: next }] })
  }, 3000)
}

onMounted(async () => {
  initBarChart()
  await fetchAgeStats()
  initLineChart()
  // 柱状图每 30s 刷新一次（独立计时器）
  barTimer = setInterval(fetchAgeStats, 30000)
})

onUnmounted(() => {
  barTimer && clearInterval(barTimer)
  lineTimer && clearInterval(lineTimer)
  barChart?.dispose()
  lineChart?.dispose()
})
</script>

<style lang="less" scoped>
.dashboard {
  width: 100%;
  color: var(--text-2);
}

.top-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}
.top-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}
.monitor-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  border-radius: var(--radius-pill);
  font-size: 12px;
  color: var(--text-3);
  background: var(--bg-elevated);
  &.active {
    color: #fff;
    background: var(--primary);
  }
}

/* 指标卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 14px;
  margin-bottom: 14px;
}
.stat-card {
  display: flex;
  align-items: center;
  gap: 14px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 18px;
  transition: var(--transition);
  &:hover {
    border-color: var(--border-strong);
    transform: translateY(-2px);
  }
  .stat-icon {
    width: 42px;
    height: 42px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary);
    background: var(--primary-soft);
  }
  .stat-label {
    font-size: 12px;
    color: var(--text-3);
    margin-bottom: 4px;
  }
  .stat-value {
    font-size: 22px;
    font-weight: 700;
    color: var(--text-1);
  }
}

/* 快捷入口 */
.quick-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
  margin-bottom: 14px;
}
.quick-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 18px;
  cursor: pointer;
  transition: var(--transition);
  &:hover {
    border-color: var(--primary);
  }
  .quick-icon {
    width: 44px;
    height: 44px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    background: var(--primary);
  }
  .quick-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-1);
  }
  .quick-desc {
    font-size: 12px;
    color: var(--text-3);
  }
  .quick-arrow {
    margin-left: auto;
    color: var(--text-4);
  }
}

/* 图表区 */
.charts-row {
  display: grid;
  grid-template-columns: 1.4fr 1fr 1fr;
  gap: 14px;
}
.chart-card {
  padding: 16px 18px;
}
.card-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-1);
  margin-bottom: 12px;
}
.chart-box {
  width: 100%;
  height: 240px;
}

/* 仪表盘 */
.gauge-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 14px;
}
.gauge {
  position: relative;
  width: 130px;
  height: 130px;
  border-radius: 50%;
  background: conic-gradient(var(--c) calc(var(--p) * 1%), var(--bg-elevated) 0);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.5s ease;
  &::before {
    content: '';
    position: absolute;
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: var(--bg-surface);
  }
  .gauge-val {
    position: relative;
    font-size: 24px;
    font-weight: 700;
    color: var(--text-1);
  }
}
.gauge-label {
  margin-top: 8px;
  font-size: 12px;
  color: var(--text-3);
}

.load-list {
  margin-bottom: 14px;
}
.load-item {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
  font-size: 12px;
  .load-label {
    width: 48px;
    color: var(--text-3);
  }
  .load-bar {
    flex: 1;
    height: 8px;
    background: var(--bg-elevated);
    border-radius: var(--radius-pill);
    overflow: hidden;
  }
  .load-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--primary), #ff7a6e);
    border-radius: var(--radius-pill);
  }
  .load-num {
    width: 38px;
    text-align: right;
    color: var(--text-3);
  }
}
.full {
  width: 100%;
}

/* 响应式 */
@media (max-width: 1280px) {
  .stat-cards { grid-template-columns: repeat(3, 1fr); }
  .charts-row { grid-template-columns: 1fr; }
}
</style>
