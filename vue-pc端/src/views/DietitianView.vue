<template>
  <div class="dietitian">
    <div class="page-head">
      <div>
        <div class="crumb">
          管理后台 <span class="sep">/</span> <span class="current">营养师管理</span>
        </div>
        <div class="title" style="margin-top:6px">营养师管理</div>
      </div>
      <span class="badge primary"><Icon name="shield" :size="13" /> SECURITY A++</span>
    </div>

    <!-- 概览卡片 -->
    <section class="stats-row">
      <div class="card stat-card" v-for="s in overview" :key="s.title" @click="show(s.tip)">
        <div class="stat-title">{{ s.title }}</div>
        <div class="stat-value">{{ s.value }} <span class="stat-sub" v-if="s.sub">{{ s.sub }}</span></div>
      </div>
    </section>

    <div class="two-column">
      <!-- 左：营养师名录 -->
      <div class="card left-col">
        <div class="card-header">
          <h2><Icon name="users" :size="18" /> 认证营养师名录</h2>
          <button class="btn btn-ghost" @click="handleExport"><Icon name="download" :size="15" /> 导出 CSV</button>
        </div>
        <div class="card-body">
          <table class="data-table">
            <thead>
              <tr>
                <th>姓名</th>
                <th>职称</th>
                <th>认证状态</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in nutritionists" :key="item.id">
                <td>{{ item.name }}</td>
                <td>{{ item.title }}</td>
                <td>
                  <span class="badge" :class="item.status === '待复审' ? 'warning' : 'success'">{{ item.status }}</span>
                </td>
                <td><span class="link" @click="show(`查看 ${item.name} 详情`)">查看</span></td>
              </tr>
              <tr v-if="nutritionists.length === 0">
                <td colspan="4" class="empty">暂无营养师数据</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 右：日历 + 流水 -->
      <div class="right-col">
        <div class="card">
          <div class="card-header">
            <h2><Icon name="calendar" :size="18" /> 排班日历概览</h2>
            <span class="month-year">{{ year }}年{{ month + 1 }}月</span>
          </div>
          <div class="card-body">
            <div class="weekdays">
              <div v-for="w in weekdays" :key="w" class="weekday">{{ w }}</div>
            </div>
            <div class="dates-grid">
              <div v-for="n in startOffset" :key="'e' + n" class="date-cell empty"></div>
              <div
                v-for="day in daysInMonth"
                :key="day"
                class="date-cell"
                :class="{ selected: selectedDate === day }"
                @click="selectDate(day)"
              >{{ day }}</div>
              <div v-for="n in trailingEmpty" :key="'t' + n" class="date-cell empty"></div>
            </div>
          </div>
          <div class="stats-footer">
            <div class="stat-item"><strong>{{ selectedDate }}日</strong><span>{{ dutyCount }} 名</span>值班</div>
            <div class="stat-item"><strong>82.5%</strong> 预约排号率</div>
            <button class="btn btn-ghost" @click="refreshDuty"><Icon name="refresh" :size="14" /> 刷新</button>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <h2><Icon name="trendingUp" :size="18" /> 专家级别流水统计</h2>
            <button class="btn btn-ghost" @click="refreshFlow"><Icon name="refresh" :size="14" /> 刷新</button>
          </div>
          <div class="card-body">
            <div class="flow-list">
              <div class="flow-item" v-for="item in flowData" :key="item.label" @click="show(`${item.label} 流水：¥${item.amount}k`)">
                <span class="flow-label">{{ item.label }}</span>
                <div class="flow-bar-container"><div class="flow-bar" :style="{ width: item.percent + '%' }"></div></div>
                <span class="flow-value">¥{{ item.amount }}k</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import {
  getNutritionists, getDutyCalendar, getFlowData, exportNutritionists
} from '@/api/request'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const { show } = useToast()

const nutritionists = ref([])
const fetchNutritionists = async () => {
  try {
    const res = await getNutritionists()
    nutritionists.value = res.data?.data || []
  } catch (e) { console.warn('营养师接口未就绪') }
}

// 日历
const weekdays = ['一', '二', '三', '四', '五', '六', '日']
const year = 2026
const month = 2
const daysInMonth = new Date(year, month + 1, 0).getDate()
const firstDay = new Date(year, month, 1).getDay()
const startOffset = firstDay === 0 ? 6 : firstDay - 1
const totalCells = startOffset + daysInMonth
const trailingEmpty = (7 - (totalCells % 7)) % 7

const dutyData = ref([])
const selectedDate = ref(new Date().getDate())
const dutyCount = computed(() => dutyData.value[selectedDate.value - 1] || 0)

const fetchDuty = async () => {
  try {
    const res = await getDutyCalendar({ year, month: month + 1 })
    dutyData.value = res.data || res
  } catch (e) {
    dutyData.value = [3,5,2,7,4,6,8,2,5,3,5,7,2,4,6,8,2,5,3,5,7,2,4,6,8,2,5,3,4,6,2]
  }
}
const selectDate = (day) => { selectedDate.value = day }
const refreshDuty = async () => { await fetchDuty(); show('值班数据已刷新', 'success') }

// 流水
const flowData = ref([])
const fetchFlow = async () => {
  try {
    const res = await getFlowData()
    flowData.value = res.data || res
  } catch (e) {
    flowData.value = [
      { label: '核心专家', percent: 80, amount: 48 },
      { label: '高级营养师', percent: 65, amount: 32 },
      { label: '普通营养师', percent: 40, amount: 18 },
      { label: '新锐营养师', percent: 25, amount: 9 }
    ]
  }
}
const refreshFlow = async () => { await fetchFlow(); show('流水数据已刷新', 'success') }

const overview = [
  { title: '今日咨询单', value: '48', sub: '(120)', tip: '今日咨询单：48（累计 120）' },
  { title: '专家好评率', value: '99.4%', tip: '专家好评率：99.4%' },
  { title: '待分配咨询', value: '07', tip: '待分配咨询：7 单' }
]

const handleExport = async () => {
  try { await exportNutritionists(); show('导出成功', 'success') }
  catch (e) { show('导出失败，请稍后重试', 'error') }
}

onMounted(async () => {
  await fetchNutritionists()
  await fetchDuty()
  await fetchFlow()
})
</script>

<style scoped lang="less">
.dietitian { width: 100%; color: var(--text-2); }

.stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; margin-bottom: 14px; }
.stat-card {
  padding: 16px 18px; cursor: pointer; transition: var(--transition);
  &:hover { border-color: var(--primary); transform: translateY(-2px); }
  .stat-title { font-size: 13px; color: var(--text-3); margin-bottom: 6px; }
  .stat-value { font-size: 26px; font-weight: 600; color: var(--text-1); display: flex; align-items: baseline; gap: 6px; }
  .stat-sub { font-size: 13px; color: var(--text-3); font-weight: 400; }
}

.two-column { display: grid; grid-template-columns: 1.6fr 1fr; gap: 14px; align-items: start; }
.left-col, .right-col { display: flex; flex-direction: column; gap: 14px; min-width: 0; }

.card-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 16px; border-bottom: 1px solid var(--border);
  h2 { font-size: 15px; color: var(--text-1); display: flex; align-items: center; gap: 8px; }
}
.card-body { padding: 14px 16px; }

.data-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.data-table th {
  text-align: left; padding: 9px 10px; background: var(--bg-surface-2);
  color: var(--text-3); font-weight: 500;
}
.data-table td { padding: 10px; border-bottom: 1px solid var(--border); color: var(--text-2); }
.data-table tr:last-child td { border-bottom: none; }
.empty { text-align: center; color: var(--text-4); padding: 28px 0; }

.link { color: var(--primary); cursor: pointer; font-size: 13px; }
.link:hover { text-decoration: underline; }

.month-year {
  font-size: 12px; color: var(--text-2);
  background: var(--bg-elevated); padding: 4px 10px; border-radius: var(--radius-pill);
}

.weekdays { display: grid; grid-template-columns: repeat(7, 1fr); text-align: center; margin-bottom: 8px; font-size: 12px; color: var(--text-4); }
.dates-grid { display: grid; grid-template-columns: repeat(7, minmax(0, 1fr)); gap: 3px; }
.date-cell {
  background: var(--bg-elevated); border-radius: var(--radius-sm);
  padding: 5px 0; text-align: center; cursor: pointer; font-size: 12px; color: var(--text-2);
  border: 1px solid transparent; transition: var(--transition);
  &:hover { border-color: var(--primary); }
  &.empty { background: transparent; cursor: default; }
  &.selected { background: var(--primary); color: #fff; border-color: var(--primary); }
}

.stats-footer {
  display: flex; align-items: center; gap: 14px;
  padding: 12px 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--text-3);
  .stat-item { display: flex; align-items: baseline; gap: 4px; strong { font-size: 16px; color: var(--text-1); } }
}

.flow-list { display: flex; flex-direction: column; gap: 12px; }
.flow-item { display: flex; align-items: center; gap: 10px; cursor: pointer; }
.flow-label { width: 92px; font-size: 12px; color: var(--text-3); }
.flow-bar-container { flex: 1; height: 6px; background: var(--bg-elevated); border-radius: var(--radius-pill); overflow: hidden; }
.flow-bar { height: 100%; background: linear-gradient(90deg, var(--primary), #ff7a6e); border-radius: var(--radius-pill); }
.flow-value { min-width: 52px; font-size: 12px; color: var(--primary); text-align: right; }

@media (max-width: 1100px) {
  .two-column { grid-template-columns: 1fr; }
  .stats-row { grid-template-columns: 1fr; }
}
</style>
