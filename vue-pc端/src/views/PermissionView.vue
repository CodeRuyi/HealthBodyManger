<template>
  <div class="permission">
    <div class="page-head">
      <div>
        <div class="crumb">
          管理后台 <span class="sep">/</span> <span class="current">权限管理</span>
        </div>
        <div class="title" style="margin-top:6px">权限管理</div>
      </div>
    </div>

    <div class="permission-body">
      <!-- 左侧：角色定义 -->
      <aside class="role-panel card">
        <div class="panel-header">
          <span>角色定义</span>
          <button class="btn btn-primary" @click="showAddDialog = true"><Icon name="plus" :size="15" /> 新增角色</button>
        </div>
        <div class="role-list">
          <div
            v-for="role in roleList"
            :key="role.id"
            class="role-item"
            :class="{ active: activeRole?.id === role.id }"
            @click="selectRole(role)"
          >
            <div class="role-meta">
              <span class="role-name">{{ role.name }}</span>
              <span class="role-type" :style="{ backgroundColor: role.color || '#888' }">{{ role.type }}</span>
            </div>
            <span class="icon-btn" title="删除角色" @click.stop="handleDeleteRole(role)"><Icon name="trash" :size="15" /></span>
          </div>
          <div v-if="roleList.length === 0" class="empty">暂无角色，请新增</div>
        </div>
      </aside>

      <!-- 右侧：权限节点配置 -->
      <section class="perm-panel card">
        <div class="panel-header">
          <span>权限节点配置：{{ activeRole?.name || '未选择角色' }}</span>
          <div>
            <button class="btn btn-ghost" @click="checkAllPerms">全选</button>
            <button class="btn btn-primary" @click="handleSave">保存配置</button>
          </div>
        </div>

        <div class="perm-list">
          <div v-for="group in permGroups" :key="group.title" class="perm-group">
            <h4 class="group-title">{{ group.title }}</h4>
            <div class="perm-items">
              <label v-for="item in group.items" :key="item.key" class="perm-item">
                <input
                  type="checkbox"
                  class="checkbox"
                  v-model="currentPerms"
                  :value="item.key"
                />
                <span class="label-text">
                  <span class="label-title">{{ item.title }}</span>
                  <span class="label-desc">{{ item.desc }}</span>
                </span>
              </label>
            </div>
          </div>
        </div>
      </section>
    </div>

    <!-- 新增角色弹窗 -->
    <div class="modal-mask" v-if="showAddDialog" @click="showAddDialog = false"></div>
    <div class="dialog" v-if="showAddDialog">
      <div class="dialog-header">
        <h3>新增角色</h3>
        <span class="modal-close" @click="showAddDialog = false"><Icon name="close" :size="18" /></span>
      </div>
      <div class="dialog-body">
        <div class="form-item">
          <label>角色名称</label>
          <input class="input" v-model="newRole.name" placeholder="请输入角色名称" />
        </div>
        <div class="form-item">
          <label>角色类型</label>
          <input class="input" v-model="newRole.type" placeholder="请输入角色类型" />
        </div>
      </div>
      <div class="dialog-footer">
        <button class="btn btn-ghost" @click="showAddDialog = false">取消</button>
        <button class="btn btn-primary" @click="handleAddRole">确定</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getRoles, addRole, deleteRole } from '@/api/request.js'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const { show } = useToast()

const roleList = ref([])
const activeRole = ref(null)
const currentPerms = ref([])

const showAddDialog = ref(false)
const newRole = ref({ name: '', type: '' })

// 权限分组（演示数据，接入后台后可替换）
const permGroups = ref([
  { title: '首页仪表盘权限', items: [
    { key: 'dashboard_view', title: '查看仪表盘', desc: '查看营收 / 用户数据' },
    { key: 'dashboard_all', title: '仪表盘全权限', desc: '查看 + 导出 + 修改' },
    { key: 'system_monitor', title: '系统监控', desc: '查看服务器负载' }
  ]},
  { title: '用户管理权限', items: [
    { key: 'user_view_all', title: '查看所有用户', desc: '查看用户信息' },
    { key: 'user_edit', title: '编辑用户信息', desc: '修改基础信息' },
    { key: 'user_delete', title: '删除用户', desc: '注销 / 封禁账号' },
    { key: 'user_all', title: '用户全权限', desc: '查看 + 编辑 + 删除' }
  ]},
  { title: '营养师管理权限', items: [
    { key: 'dietitian_view', title: '查看营养师', desc: '查看营养师列表' },
    { key: 'dietitian_audit', title: '审核营养师', desc: '审核入驻申请' },
    { key: 'dietitian_all', title: '营养师全权限', desc: '查看 + 审核 + 编辑' }
  ]},
  { title: '科普知识库权限', items: [
    { key: 'knowledge_view', title: '查看科普内容', desc: '查看文章 / 视频' },
    { key: 'knowledge_edit', title: '编辑科普内容', desc: '编辑自己的内容' }
  ]}
])

const checkAllPerms = () => {
  currentPerms.value = permGroups.value.flatMap(g => g.items.map(i => i.key))
}

const selectRole = (role) => {
  activeRole.value = role
  currentPerms.value = JSON.parse(role.perms || '[]')
}

const handleDeleteRole = (role) => {
  if (!confirm(`确定删除角色「${role.name}」吗？`)) return
  deleteRole(role.id).then(() => {
    show('删除成功', 'success')
    fetchRoles()
  }).catch(() => show('删除失败', 'error'))
}

const handleAddRole = () => {
  if (!newRole.value.name || !newRole.value.type) { show('请填写完整信息', 'warning'); return }
  addRole({ name: newRole.value.name, type: newRole.value.type }).then(() => {
    show('新增成功', 'success')
    showAddDialog.value = false
    newRole.value = { name: '', type: '' }
    fetchRoles()
  }).catch(() => show('新增失败', 'error'))
}

const handleSave = () => {
  if (!activeRole.value) { show('请先选择角色', 'warning'); return }
  // 本地已更新 currentPerms，保存接口接入后此处提交到后端
  show('权限配置已保存', 'success')
}

const fetchRoles = () => {
  getRoles({}).then(res => {
    roleList.value = res.data.data || []
    if (roleList.value.length) selectRole(roleList.value[0])
  }).catch(() => show('角色列表加载失败', 'error'))
}

onMounted(() => fetchRoles())
</script>

<style scoped lang="less">
.permission { width: 100%; color: var(--text-2); }

.permission-body { display: flex; gap: 16px; align-items: stretch; }
.role-panel { width: 320px; flex-shrink: 0; display: flex; flex-direction: column; padding: 0; }
.perm-panel { flex: 1; display: flex; flex-direction: column; padding: 0; min-width: 0; }

.panel-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: 16px 18px; border-bottom: 1px solid var(--border); font-size: 15px; font-weight: 500; color: var(--text-1);
}

.role-list { flex: 1; overflow-y: auto; padding: 10px; }
.role-item {
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 14px; margin-bottom: 8px; border-radius: var(--radius-sm); cursor: pointer; transition: var(--transition);
  &:hover { background: var(--bg-elevated); }
  &.active { background: var(--primary-soft); }
  .role-meta { display: flex; align-items: center; gap: 8px; }
  .role-name { font-size: 14px; color: var(--text-1); }
  .role-type { font-size: 11px; padding: 2px 8px; border-radius: var(--radius-pill); color: #fff; }
}
.empty { color: var(--text-4); font-size: 13px; padding: 20px; text-align: center; }

.perm-list { flex: 1; overflow-y: auto; padding: 18px; }
.perm-group { margin-bottom: 22px; }
.group-title { font-size: 13px; color: var(--text-3); margin-bottom: 12px; }
.perm-items { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.perm-item {
  display: flex; align-items: center; gap: 10px; padding: 12px;
  background: var(--bg-elevated); border: 1px solid transparent; border-radius: var(--radius-sm); cursor: pointer; transition: var(--transition);
  &:hover { border-color: var(--border-strong); }
  .label-text { display: flex; flex-direction: column; }
  .label-title { font-size: 14px; color: var(--text-1); }
  .label-desc { font-size: 12px; color: var(--text-4); }
}
.checkbox { width: 16px; height: 16px; accent-color: var(--primary); cursor: pointer; }

/* 弹窗 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 1000; display: flex; align-items: center; justify-content: center; }
.dialog {
  width: 400px; background: var(--bg-surface); border: 1px solid var(--border-strong);
  border-radius: var(--radius); z-index: 1001;
  .dialog-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid var(--border); h3 { margin: 0; color: var(--text-1); font-size: 16px; } }
  .modal-close { color: var(--text-3); cursor: pointer; display: inline-flex; &:hover { color: var(--primary); } }
  .dialog-body { padding: 20px; }
  .dialog-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 14px 20px; border-top: 1px solid var(--border); }
}
.form-item { margin-bottom: 16px; label { display: block; margin-bottom: 8px; font-size: 13px; color: var(--text-3); } .input { width: 100%; } }

@media (max-width: 980px) {
  .permission-body { flex-direction: column; }
  .role-panel { width: 100%; }
  .perm-items { grid-template-columns: 1fr; }
}
</style>
