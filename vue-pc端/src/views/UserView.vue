<template>
  <div class="user-management">
    <div class="page-head">
      <div>
        <div class="crumb">
          管理后台 <span class="sep">/</span> <span class="current">用户管理</span>
        </div>
        <div class="title" style="margin-top:6px">用户管理</div>
      </div>
      <button class="btn btn-primary" @click="fetchUsers">
        <Icon name="refresh" :size="16" /> 手动刷新
      </button>
    </div>

    <!-- 检索栏 -->
    <div class="search-bar">
      <div class="search-input-wrap">
        <Icon name="search" :size="16" class="search-ico" />
        <input
          class="input"
          type="text"
          placeholder="搜索用户名..."
          v-model="searchUsername"
          @keyup.enter="handleUsernameSearch"
        />
      </div>
      <select class="select" v-model="searchStatus" @change="handleStatusFilter">
        <option value="">用户状态：全部</option>
        <option value="轻度暴食">轻度暴食</option>
        <option value="暴食预警">暴食预警</option>
        <option value="暴食倾向">暴食倾向</option>
        <option value="正常">正常</option>
      </select>
      <select class="select" v-model="searchNutritionist" @change="handleStatusFilter">
        <option value="">关联营养师：全部</option>
        <option value="高级营养师">高级营养师</option>
        <option value="普通营养师">普通营养师</option>
      </select>
      <button class="btn btn-ghost" @click="handleReset">
        <Icon name="close" :size="15" /> 重置
      </button>
    </div>

    <!-- 表格 -->
    <div class="table-container card">
      <table class="user-table">
        <thead>
          <tr>
            <th>用户信息</th>
            <th>近期饮食倾向</th>
            <th>活跃度</th>
            <th>用户标签</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr
            class="user-row"
            v-for="(user, index) in userList"
            :key="user.id"
            :style="{ animationDelay: index * 0.04 + 's' }"
          >
            <td>
              <div class="user-info-cell">
                <img
                  :src="`https://api.dicebear.com/7.x/avataaars/svg?seed=${user.username}`"
                  :alt="user.username"
                  class="avatar"
                />
                <div class="user-details">
                  <div class="username">{{ user.username }} <span class="uid">UID:{{ user.uid }}</span></div>
                  <div class="register-time">{{ user.register_time }} 注册</div>
                </div>
              </div>
            </td>
            <td><span class="badge warning">{{ user.diet_status }}</span></td>
            <td>
              <div class="progress-bar">
                <div class="progress" :style="{ width: (user.active_score || 0) + '%' }"></div>
              </div>
            </td>
            <td>
              <span class="tag" v-for="tag in userTags(user)" :key="tag">{{ tag }}</span>
            </td>
            <td>
              <span class="badge" :class="statusClass(user.status)" @click="filterByStatus(user.diet_status)" style="cursor:pointer">
                {{ user.status }}
              </span>
            </td>
            <td>
              <div class="actions">
                <span class="icon-btn" title="编辑" @click="openEditModal(user)"><Icon name="pencil" :size="16" /></span>
                <span class="icon-btn" title="删除" @click="handleDeleteUser(user)"><Icon name="trash" :size="16" /></span>
              </div>
            </td>
          </tr>
          <tr v-if="userList.length === 0">
            <td colspan="6" class="empty">暂无用户数据</td>
          </tr>
        </tbody>
      </table>

      <div class="table-footer" v-if="totalCount > 0">
        <span class="table-info">
          显示 {{ (currentPage - 1) * pageSize + 1 }} 到 {{ Math.min(currentPage * pageSize, totalCount) }} 条，共 {{ totalCount }} 名用户
        </span>
        <div class="pagination">
          <span class="page-btn" @click="prevPage" :class="{ disabled: currentPage === 1 }"><Icon name="chevronLeft" :size="16" /></span>
          <span
            class="page-btn"
            v-for="page in totalPages"
            :key="page"
            :class="{ active: currentPage === page }"
            @click="goToPage(page)"
          >{{ page }}</span>
          <span class="page-btn" @click="nextPage" :class="{ disabled: currentPage === totalPages }"><Icon name="chevronRight" :size="16" /></span>
        </div>
      </div>
    </div>
  </div>

  <!-- 编辑弹窗 -->
  <div class="modal-overlay" v-if="showEditModal" @click="closeEditModal">
    <div class="modal-content" @click.stop>
      <h3>编辑用户信息</h3>
      <form @submit.prevent="saveUser">
        <div class="form-grid">
          <div class="form-item">
            <label>UID</label>
            <input class="input" type="text" v-model="editForm.uid" disabled />
          </div>
          <div class="form-item">
            <label>用户名</label>
            <input class="input" type="text" v-model="editForm.username" required />
          </div>
          <div class="form-item">
            <label>手机号</label>
            <input class="input" type="text" v-model="editForm.phone" />
          </div>
          <div class="form-item">
            <label>性别</label>
            <select class="select" v-model="editForm.gender">
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>
          <div class="form-item">
            <label>年龄</label>
            <input class="input" type="number" v-model="editForm.age" />
          </div>
          <div class="form-item">
            <label>饮食状态</label>
            <select class="select" v-model="editForm.diet_status">
              <option value="正常">正常</option>
              <option value="轻度暴食">轻度暴食</option>
              <option value="暴食预警">暴食预警</option>
              <option value="暴食倾向">暴食倾向</option>
            </select>
          </div>
          <div class="form-item">
            <label>用户状态</label>
            <select class="select" v-model="editForm.status">
              <option value="正常">正常</option>
              <option value="监控中">监控中</option>
              <option value="重点关注">重点关注</option>
            </select>
          </div>
          <div class="form-item">
            <label>活跃度</label>
            <input class="input" type="number" v-model="editForm.active_score" min="0" max="100" />
          </div>
        </div>
        <div class="form-item">
          <label>用户标签</label>
          <input class="input" type="text" v-model="editForm.tags" placeholder="多个标签用逗号分隔" />
        </div>
        <div class="modal-actions">
          <button type="button" class="btn btn-ghost" @click="closeEditModal">取消</button>
          <button type="submit" class="btn btn-primary">保存</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { getUserList, updateUser, deleteUser, searchUserByUsername } from '@/api/request.js'
import Icon from '@/components/Icon.vue'

const userList = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(0)

const searchUsername = ref('')
const searchStatus = ref('')
const searchNutritionist = ref('')

const showEditModal = ref(false)
const editForm = ref({
  id: null, uid: '', username: '', phone: '', gender: '', age: null,
  diet_status: '', status: '', tags: '', active_score: 0
})

const fetchUsers = async () => {
  const res = await getUserList(currentPage.value, pageSize.value)
  userList.value = res.data.data.list || []
  totalCount.value = res.data.data.total || 0
}
onMounted(() => fetchUsers())

const totalPages = computed(() => Math.ceil((totalCount.value || 0) / pageSize.value) || 1)

const handleUsernameSearch = async () => {
  const keyword = searchUsername.value.trim()
  if (!keyword) return fetchUsers()
  const res = await searchUserByUsername(keyword)
  userList.value = res.data.data || []
  totalCount.value = userList.value.length
  currentPage.value = 1
}

const handleStatusFilter = async () => {
  if (searchStatus.value === '') return fetchUsers()
  const res = await getUserList(1, 999)
  let list = res.data.data.list || []
  if (searchStatus.value) {
    list = list.filter(item => (item.diet_status || '').trim() === searchStatus.value.trim())
  }
  if (searchNutritionist.value === '高级营养师') list = list.filter(i => i.dietitian_id === 1)
  if (searchNutritionist.value === '普通营养师') list = list.filter(i => i.dietitian_id === 2)
  userList.value = list
  totalCount.value = list.length
  currentPage.value = 1
}

const filterByStatus = (dietStatus) => {
  searchUsername.value = ''
  searchStatus.value = dietStatus
  searchNutritionist.value = ''
  handleStatusFilter()
}

const handleReset = () => {
  searchUsername.value = ''
  searchStatus.value = ''
  searchNutritionist.value = ''
  currentPage.value = 1
  fetchUsers()
}

const prevPage = () => { if (currentPage.value > 1) { currentPage.value--; fetchUsers() } }
const nextPage = () => { if (currentPage.value < totalPages.value) { currentPage.value++; fetchUsers() } }
const goToPage = (page) => { if (page >= 1 && page <= totalPages.value) { currentPage.value = page; fetchUsers() } }

const userTags = (user) => (user.tags ? user.tags.split(',').filter(t => t.trim()) : [])

const statusClass = (status) => ({
  '正常': 'success',
  '监控中': 'primary',
  '重点关注': 'warning'
}[status] || '')

const openEditModal = (user) => { editForm.value = { ...user }; showEditModal.value = true }
const closeEditModal = () => { showEditModal.value = false }
const saveUser = async () => {
  await updateUser(editForm.value.id, editForm.value)
  closeEditModal()
  fetchUsers()
}

const handleDeleteUser = async (user) => {
  if (confirm('确定要删除该用户吗？')) {
    await deleteUser(user.id)
    fetchUsers()
  }
}
</script>

<style lang="less" scoped>
.user-management {
  width: 100%;
  color: var(--text-2);
}

.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
  flex-wrap: wrap;
  align-items: center;
  .search-input-wrap {
    position: relative;
    flex: 1;
    min-width: 220px;
    .search-ico {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-4);
    }
    .input { width: 100%; padding-left: 34px; }
  }
}

.table-container { padding: 0; overflow: hidden; }

.user-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
  th, td {
    padding: 13px 16px;
    text-align: left;
    border-bottom: 1px solid var(--border);
  }
  th { color: var(--text-3); font-weight: 500; background: var(--bg-surface-2); }
  td { color: var(--text-2); }
}

.user-row {
  opacity: 0;
  transform: translateY(8px);
  animation: fadeInUp 0.35s ease forwards;
  transition: background-color 0.2s ease;
  &:hover { background: var(--bg-elevated); }
  &:last-child td { border-bottom: none; }
}
@keyframes fadeInUp { to { opacity: 1; transform: translateY(0); } }

.empty { text-align: center; color: var(--text-4); padding: 40px 0; }

.user-info-cell {
  display: flex;
  align-items: center;
  gap: 10px;
  .avatar {
    width: 34px; height: 34px;
    border-radius: 50%;
    background: var(--bg-elevated);
    object-fit: cover;
  }
  .username { font-weight: 500; color: var(--text-1); }
  .uid { font-size: 11px; color: var(--text-4); margin-left: 4px; font-weight: 400; }
  .register-time { color: var(--text-4); font-size: 12px; }
}

.progress-bar {
  width: 90px; height: 6px;
  background: var(--bg-elevated);
  border-radius: var(--radius-pill);
  overflow: hidden;
  .progress { height: 100%; background: linear-gradient(90deg, var(--primary), #ff7a6e); }
}

.tag {
  display: inline-block;
  background: var(--bg-elevated);
  padding: 2px 7px;
  border-radius: var(--radius-sm);
  font-size: 11px;
  margin-right: 4px;
  color: var(--text-2);
}

.actions { display: flex; gap: 4px; }

.table-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px;
  font-size: 12px;
  color: var(--text-3);
}
.pagination { display: flex; gap: 6px; }
.page-btn {
  min-width: 30px; height: 30px; padding: 0 6px;
  display: inline-flex; align-items: center; justify-content: center;
  border-radius: var(--radius-sm);
  background: var(--bg-elevated);
  color: var(--text-2);
  cursor: pointer;
  &.active { background: var(--primary); color: #fff; }
  &.disabled { opacity: 0.4; cursor: not-allowed; }
}

/* 弹窗 */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex; align-items: center; justify-content: center;
  z-index: 1000;
}
.modal-content {
  width: 560px; max-width: 92%;
  background: var(--bg-surface);
  border: 1px solid var(--border-strong);
  border-radius: var(--radius);
  padding: 22px 24px;
  h3 { margin-bottom: 18px; color: var(--text-1); font-size: 17px; }
}
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
}
.form-item { margin-bottom: 14px; label { display: block; margin-bottom: 6px; color: var(--text-3); font-size: 13px; } }
.form-item .input, .form-item .select { width: 100%; }
.modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 8px; }
</style>
