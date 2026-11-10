<template>
  <div class="member">
    <div class="page-head">
      <div>
        <div class="crumb">
          管理后台 <span class="sep">/</span> <span class="current">会员管理</span>
        </div>
        <div class="title" style="margin-top:6px">会员管理</div>
      </div>
    </div>

    <!-- 会员等级概览 -->
    <section class="card-container">
      <div class="card tier" :class="t.tier" v-for="t in tiers" :key="t.title">
        <div class="card-title">{{ t.title }}</div>
        <div class="card-count">{{ t.count }}</div>
        <div class="card-info" v-for="info in t.infos" :key="info">{{ info }}</div>
      </div>
    </section>

    <!-- 付费会员列表 -->
    <section class="card table-container">
      <div class="table-header"><h2>付费会员近期动态</h2></div>
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>会员ID</th>
              <th>会员姓名</th>
              <th>等级身份</th>
              <th>累计付费</th>
              <th>到期时间</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in memberList" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.username }}</td>
              <td>{{ item.level }}</td>
              <td class="money">¥ {{ item.total_fee }}</td>
              <td>{{ item.expire_time }}</td>
              <td><span class="badge" :class="item.status === 1 ? 'success' : 'warning'">{{ item.status === 1 ? '有效' : '已过期' }}</span></td>
              <td>
                <button class="btn btn-ghost" @click="openModal(item)"><Icon name="pencil" :size="14" /> 配置策略</button>
              </td>
            </tr>
            <tr v-if="memberList.length === 0">
              <td colspan="7" class="empty">暂无会员数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- 策略配置弹窗 -->
    <div class="modal-overlay" v-if="showModal" @click="closeModal"></div>
    <div class="modal-simple" v-if="showModal">
      <div class="modal-header">
        <h2>策略配置 · 暴食干预</h2>
        <span class="modal-close" @click="closeModal"><Icon name="close" :size="18" /></span>
      </div>
      <div class="modal-body">
        <div class="info-row" v-for="f in modalFields" :key="f.key">
          <div class="info-label">{{ f.label }}</div>
          <div class="info-value">
            <input class="input" :type="f.type" v-model="currentMember[f.key]" />
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-ghost" @click="closeModal">取消</button>
        <button class="btn btn-primary" @click="submitStrategy">提交策略</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMemberList, updateMemberStrategy } from '@/api/request'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const { show } = useToast()

const memberList = ref([])
const showModal = ref(false)

const tiers = [
  { title: '普通用户', count: 499, tier: 'normal', infos: ['转化率：5%', '无专项营养师指导权限'] },
  { title: 'VIP 会员', count: 124, tier: 'silver', infos: ['ARPU：¥19.9 / 月', '含暴食心理干预课程'] },
  { title: '高级会员', count: 58, tier: 'gold', infos: ['核心权益：24H 实时监控', '系统最高保护权限等级'] }
]

const modalFields = [
  { key: 'id', label: '会员 ID', type: 'text' },
  { key: 'username', label: '会员姓名', type: 'text' },
  { key: 'level', label: '等级身份', type: 'text' },
  { key: 'total_fee', label: '累计付费', type: 'number' },
  { key: 'expire_time', label: '到期时间', type: 'date' },
  { key: 'status', label: '当前状态', type: 'number' }
]

const currentMember = ref({ id: '', username: '', level: '', total_fee: 0, expire_time: '', status: 1 })

const fetchMemberList = async () => {
  try {
    const res = await getMemberList()
    memberList.value = res.data?.data || []
  } catch (e) { show('会员列表加载失败', 'error') }
}

const openModal = (member) => {
  currentMember.value = { ...member }
  showModal.value = true
}
const closeModal = () => {
  showModal.value = false
  currentMember.value = { id: '', username: '', level: '', total_fee: 0, expire_time: '', status: 1 }
}
const submitStrategy = async () => {
  try {
    await updateMemberStrategy(currentMember.value)
    await fetchMemberList()
    closeModal()
    show('策略配置成功，已同步', 'success')
  } catch (e) { show('配置失败，请稍后重试', 'error') }
}

onMounted(() => fetchMemberList())
</script>

<style scoped lang="less">
.member { width: 100%; color: var(--text-2); }

.card-container { display: flex; gap: 16px; margin-bottom: 16px; flex-wrap: wrap; }
.card {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
}
.tier {
  flex: 1; min-width: 200px; max-width: 280px; padding: 20px;
  border-top: 3px solid var(--border-strong);
  &.normal  { border-top-color: #909399; }
  &.silver  { border-top-color: #409eff; }
  &.gold    { border-top-color: #ff9500; }
  .card-title { font-size: 13px; color: var(--text-3); margin-bottom: 8px; }
  .card-count { font-size: 28px; font-weight: 700; color: var(--text-1); margin-bottom: 8px; }
  .card-info { font-size: 12px; color: var(--text-3); margin-top: 4px; }
}

.table-container { padding: 0; overflow: hidden; }
.table-header { padding: 16px 18px; border-bottom: 1px solid var(--border); h2 { font-size: 15px; color: var(--text-1); margin: 0; } }
.table-wrapper { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th { padding: 14px 18px; text-align: left; font-size: 13px; color: var(--text-3); border-bottom: 1px solid var(--border); background: var(--bg-surface-2); }
td { padding: 14px 18px; font-size: 13px; border-bottom: 1px solid var(--border); color: var(--text-2); }
tbody tr { transition: background 0.2s; &:hover { background: var(--bg-elevated); } &:last-child td { border-bottom: none; } }
.money { color: var(--text-1); font-weight: 500; }
.empty { text-align: center; color: var(--text-4); padding: 36px 0; }

/* 弹窗 */
.modal-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.7);
  display: flex; align-items: center; justify-content: center; z-index: 999;
}
.modal-simple {
  width: 480px; max-width: 92%;
  background: var(--bg-surface); border: 1px solid var(--border-strong); border-radius: var(--radius); z-index: 1000;
  .modal-header {
    display: flex; align-items: center; justify-content: space-between;
    padding: 16px 20px; border-bottom: 1px solid var(--border);
    h2 { font-size: 16px; color: var(--text-1); margin: 0; }
  }
  .modal-close { color: var(--text-3); cursor: pointer; display: inline-flex; &:hover { color: var(--primary); } }
  .modal-body { padding: 18px 20px; }
  .modal-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 14px 20px; border-top: 1px solid var(--border); }
}
.info-row { display: flex; align-items: center; padding: 8px 0; border-bottom: 1px dashed var(--border); }
.info-label { width: 90px; font-size: 13px; color: var(--text-3); flex-shrink: 0; }
.info-value { flex: 1; .input { width: 100%; } }

@media (max-width: 900px) { .card-container { flex-direction: column; } }
</style>
