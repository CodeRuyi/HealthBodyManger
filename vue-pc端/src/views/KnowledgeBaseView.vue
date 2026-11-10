<template>
  <div class="knowledge">
    <div class="crumb">
      管理后台 <span class="sep">/</span> <span class="current">科普知识库</span>
    </div>

    <div class="content-wrap">
      <!-- 左侧：分类 + 热度 -->
      <aside class="left-panel">
        <div class="card cate-box">
          <div class="panel-title">知识分类</div>
          <div class="cate-list">
            <div class="cate-item" :class="{ active: currentCate === 'all' }" @click="changeCate('all')">
              全部文章 <span class="count">{{ articleList.length }}</span>
            </div>
            <div
              class="cate-item"
              v-for="item in cateList"
              :key="item.id"
              :class="{ active: currentCate === item.slug }"
              @click="changeCate(item.slug)"
            >
              {{ item.name }} <span class="count">{{ getCateCount(item.slug) }}</span>
            </div>
          </div>
        </div>

        <div class="card hot-box">
          <div class="panel-title"><Icon name="fire" :size="15" /> 热度排行榜</div>
          <div class="hot-list">
            <div v-if="hotList.length === 0" class="empty-hot">暂无热度数据</div>
            <div class="hot-item" v-for="(item, index) in hotList" :key="index" v-else>
              <span class="rank">{{ index + 1 }}</span>
              <span class="title">{{ item.title }}</span>
            </div>
          </div>
        </div>
      </aside>

      <!-- 右侧：文章列表 -->
      <section class="right-panel">
        <div class="top-bar">
          <div class="search-input-wrap">
            <Icon name="search" :size="16" class="search-ico" />
            <input class="input" type="text" placeholder="搜索标题、摘要..." v-model="keyword" @keyup.enter="getArticleList" />
          </div>
          <button class="btn btn-primary" @click="openPublishModal"><Icon name="plus" :size="15" /> 发布新内容</button>
        </div>

        <div class="status-filter">
          <button class="status-btn" :class="{ active: currentStatus === 'published' }" @click="changeStatus('published')">已发布</button>
          <button class="status-btn" :class="{ active: currentStatus === 'draft' }" @click="changeStatus('draft')">
            草稿箱 <span class="draft-count">{{ draftCount }}</span>
          </button>
          <button class="status-btn" :class="{ active: currentStatus === 'offline' }" @click="changeStatus('offline')">已下架</button>
        </div>

        <div class="article-list">
          <div v-if="articleList.length === 0" class="empty-article card">暂无文章数据，请发布新内容</div>
          <div class="article-item card" v-for="item in articleList" :key="item.id" v-else>
            <div class="article-header">
              <span class="cat-tag" :class="getTagClass(item.cate)">{{ getCateName(item.cate) }}</span>
              <span class="title">{{ item.title }}</span>
            </div>
            <div class="article-info">
              <span><Icon name="eye" :size="14" /> {{ item.view }}</span>
              <span><Icon name="comment" :size="14" /> {{ item.comment }}</span>
              <span>{{ item.date }}</span>
              <span>作者：{{ item.author }}</span>
            </div>
            <div class="operate-btn">
              <span v-if="item.isHot" class="mark hot"><Icon name="fire" :size="13" /> 热</span>
              <span v-if="item.isEssence" class="mark essence">精</span>
              <span class="icon-btn" title="下架" @click="operateArticle(item.id, 'offline')"><Icon name="close" :size="16" /></span>
              <span class="icon-btn" title="编辑" @click="goEdit(item.id)"><Icon name="pencil" :size="16" /></span>
              <span class="icon-btn" title="删除" @click="openDeleteModal(item.id)"><Icon name="trash" :size="16" /></span>
            </div>
          </div>
        </div>
      </section>
    </div>

    <!-- 发布弹窗 -->
    <div class="modal-mask" v-if="showPublishModal" @click="closePublishModal"></div>
    <div class="modal" v-if="showPublishModal">
      <div class="modal-header">
        <h3>发布新文章</h3>
        <span class="modal-close" @click="closePublishModal"><Icon name="close" :size="18" /></span>
      </div>
      <div class="modal-body">
        <div class="form-item">
          <label>文章标题</label>
          <input class="input" type="text" v-model="newArticle.title" placeholder="请输入文章标题" />
        </div>
        <div class="form-item">
          <label>文章分类</label>
          <select class="select" v-model="newArticle.cate">
            <option value="selfHelp">自救指南</option>
            <option value="emotion">情绪调节</option>
            <option value="lowCal">低卡食谱</option>
            <option value="scienceEat">科学进食</option>
          </select>
        </div>
        <div class="form-item">
          <label>文章摘要</label>
          <textarea class="input" v-model="newArticle.summary" placeholder="请输入文章摘要（500字以内）" rows="3"></textarea>
        </div>
        <div class="form-item">
          <label>文章内容</label>
          <textarea class="input" v-model="newArticle.content" placeholder="请输入文章详细内容" rows="7"></textarea>
        </div>
        <div class="form-item">
          <label>作者</label>
          <input class="input" type="text" v-model="newArticle.author" placeholder="请输入作者名称" />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-ghost" @click="closePublishModal">取消</button>
        <button class="btn btn-primary" @click="submitPublish">发布</button>
      </div>
    </div>

    <!-- 编辑弹窗 -->
    <div class="modal-mask" v-if="showEditModal" @click="closeEditModal"></div>
    <div class="modal" v-if="showEditModal">
      <div class="modal-header">
        <h3>编辑文章</h3>
        <span class="modal-close" @click="closeEditModal"><Icon name="close" :size="18" /></span>
      </div>
      <div class="modal-body">
        <div class="form-item">
          <label>文章标题</label>
          <input class="input" type="text" v-model="editArticle.title" placeholder="请输入文章标题" />
        </div>
        <div class="form-item">
          <label>文章分类</label>
          <select class="select" v-model="editArticle.cate">
            <option value="selfHelp">自救指南</option>
            <option value="emotion">情绪调节</option>
            <option value="lowCal">低卡食谱</option>
            <option value="scienceEat">科学进食</option>
          </select>
        </div>
        <div class="form-item">
          <label>文章摘要</label>
          <textarea class="input" v-model="editArticle.summary" placeholder="请输入文章摘要（500字以内）" rows="3"></textarea>
        </div>
        <div class="form-item">
          <label>文章内容</label>
          <textarea class="input" v-model="editArticle.content" placeholder="请输入文章详细内容" rows="7"></textarea>
        </div>
        <div class="form-item">
          <label>作者</label>
          <input class="input" type="text" v-model="editArticle.author" placeholder="请输入作者名称" />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-ghost" @click="closeEditModal">取消</button>
        <button class="btn btn-primary" @click="submitEdit">保存修改</button>
      </div>
    </div>

    <!-- 删除确认弹窗 -->
    <div class="modal-mask" v-if="showDeleteModal" @click="closeDeleteModal"></div>
    <div class="modal small" v-if="showDeleteModal">
      <div class="modal-header">
        <h3>确认删除</h3>
        <span class="modal-close" @click="closeDeleteModal"><Icon name="close" :size="18" /></span>
      </div>
      <div class="modal-body">
        <p class="confirm-text">是否确定删除这篇文章？删除后将无法恢复！</p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-ghost" @click="closeDeleteModal">取消</button>
        <button class="btn btn-primary" @click="submitDelete">确认删除</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import {
  getKnowledgeList, getKnowledgeHot, operateKnowledge, publishKnowledge, getKnowledgeCate
} from '@/api/request'
import Icon from '@/components/Icon.vue'
import { useToast } from '@/composables/useToast'

const { show } = useToast()

const keyword = ref('')
const currentCate = ref('all')
const currentStatus = ref('published')
const articleList = ref([])
const hotList = ref([])
const cateList = ref([])

const showPublishModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const deleteArticleId = ref('')

const newArticle = ref({
  title: '', cate: 'selfHelp', summary: '', content: '', author: '',
  view: 0, comment: 0, date: new Date().toLocaleDateString(), status: 'published', isHot: false, isEssence: false
})
const editArticle = ref({
  id: '', title: '', cate: 'selfHelp', summary: '', content: '', author: '',
  view: 0, comment: 0, date: '', status: 'published', isHot: false, isEssence: false
})

const draftCount = computed(() => articleList.value.filter(i => i.status === 'draft').length)

onMounted(() => { getCateList(); getArticleList(); getHotList() })

function getCateList() {
  getKnowledgeCate().then(res => { cateList.value = res.data?.data || [] })
    .catch(() => { cateList.value = [] })
}
function getArticleList() {
  const params = { cateId: currentCate.value, status: currentStatus.value, keyword: keyword.value }
  getKnowledgeList(params).then(res => { articleList.value = res.data?.data || [] })
    .catch(() => { articleList.value = [] })
}
function getHotList() {
  getKnowledgeHot().then(res => { hotList.value = res.data?.data || [] })
    .catch(() => { hotList.value = [] })
}

function changeCate(cate) { currentCate.value = cate; getArticleList() }
function changeStatus(status) { currentStatus.value = status; getArticleList() }

function getCateCount(slug) {
  const map = { 'self-help': 'selfHelp', 'emotion': 'emotion', 'recipe': 'lowCal', 'science': 'scienceEat' }
  return articleList.value.filter(i => i.cate === map[slug]).length
}

function openPublishModal() {
  newArticle.value = {
    title: '', cate: 'selfHelp', summary: '', content: '', author: '',
    view: 0, comment: 0, date: new Date().toLocaleDateString(), status: 'published', isHot: false, isEssence: false
  }
  showPublishModal.value = true
}
function closePublishModal() { showPublishModal.value = false }

function submitPublish() {
  if (!newArticle.value.title || !newArticle.value.content) { show('标题和内容不能为空', 'warning'); return }
  publishKnowledge(newArticle.value).then(res => {
    if (res.code === 200 || res.data?.code === 200) { show('发布成功', 'success'); closePublishModal(); getArticleList() }
    else show('发布失败：' + (res.msg || res.data?.msg || '接口异常'), 'error')
  }).catch(() => show('发布失败：网络异常', 'error'))
}

function goEdit(id) {
  const target = articleList.value.find(i => i.id === id)
  if (target) { editArticle.value = { ...target }; showEditModal.value = true }
  else show('未找到该文章数据', 'error')
}
function closeEditModal() { showEditModal.value = false }

function submitEdit() {
  if (!editArticle.value.title || !editArticle.value.content) { show('标题和内容不能为空', 'warning'); return }
  operateKnowledge({ id: editArticle.value.id, type: 'update', data: editArticle.value }).then(res => {
    if (res.code === 200 || res.data?.code === 200) { show('修改成功', 'success'); closeEditModal(); getArticleList() }
    else show('修改失败：' + (res.msg || res.data?.msg || '接口异常'), 'error')
  }).catch(() => show('修改失败：网络异常', 'error'))
}

function openDeleteModal(id) { deleteArticleId.value = id; showDeleteModal.value = true }
function closeDeleteModal() { showDeleteModal.value = false; deleteArticleId.value = '' }

function submitDelete() {
  operateKnowledge({ id: deleteArticleId.value, type: 'delete' }).then(res => {
    if (res.code === 200 || res.data?.code === 200) { show('删除成功', 'success'); closeDeleteModal(); getArticleList() }
    else show('删除失败：' + (res.msg || res.data?.msg || '接口异常'), 'error')
  }).catch(() => show('删除失败：网络异常', 'error'))
}

function operateArticle(id, type) {
  if (type === 'offline') {
    if (!confirm('确定下架这篇文章吗？')) return
    operateKnowledge({ id, type }).then(res => {
      if (res.code === 200 || res.data?.code === 200) { show(res.msg || res.data?.msg || '下架成功', 'success'); getArticleList() }
      else show('下架失败：' + (res.msg || res.data?.msg || '接口异常'), 'error')
    }).catch(() => show('下架失败：网络异常', 'error'))
  }
}

function getTagClass(cate) {
  return { selfHelp: 'c-selfHelp', emotion: 'c-emotion', lowCal: 'c-lowCal', scienceEat: 'c-scienceEat' }[cate] || ''
}
function getCateName(cate) {
  return { selfHelp: '自救指南', emotion: '情绪调节', lowCal: '低卡食谱', scienceEat: '科学进食' }[cate] || '未知'
}
</script>

<style lang="less" scoped>
.knowledge { width: 100%; color: var(--text-2); }

.crumb { margin-bottom: 16px; font-size: 13px; color: var(--text-3); .current { color: var(--primary); } }
.sep { margin: 0 6px; color: var(--text-4); }

.content-wrap { display: flex; gap: 16px; align-items: flex-start; }

.left-panel { width: 220px; flex-shrink: 0; }
.cate-box, .hot-box { padding: 14px; margin-bottom: 16px; }
.panel-title { display: flex; align-items: center; gap: 6px; font-weight: 600; color: var(--text-1); margin-bottom: 10px; font-size: 14px; }
.cate-item {
  display: flex; justify-content: space-between; align-items: center;
  padding: 8px 10px; cursor: pointer; border-radius: var(--radius-sm); color: var(--text-2); transition: var(--transition);
  &:hover { background: var(--bg-elevated); }
  &.active { background: var(--primary-soft); color: var(--primary); font-weight: 500; }
  .count { background: var(--bg-elevated); min-width: 20px; height: 20px; border-radius: 10px; text-align: center; font-size: 11px; line-height: 20px; color: var(--text-3); }
  &.active .count { background: var(--primary); color: #fff; }
}
.hot-item { display: flex; align-items: center; gap: 8px; padding: 7px 4px; font-size: 13px; color: var(--text-2); }
.hot-item .rank { background: var(--primary); color: #fff; width: 20px; height: 20px; border-radius: var(--radius-sm); text-align: center; font-size: 12px; line-height: 20px; flex-shrink: 0; }
.hot-item .title { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.empty-hot { color: var(--text-4); font-size: 13px; padding: 8px 4px; }

.right-panel { flex: 1; min-width: 0; }
.top-bar { display: flex; justify-content: space-between; gap: 12px; margin-bottom: 14px; }
.search-input-wrap { position: relative; flex: 1; max-width: 360px; .search-ico { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-4); } .input { width: 100%; padding-left: 34px; } }

.status-filter { display: flex; gap: 8px; margin-bottom: 14px; }
.status-btn {
  background: var(--bg-surface); color: var(--text-3); border: 1px solid var(--border);
  border-radius: var(--radius-sm); padding: 7px 14px; cursor: pointer; font-size: 13px; transition: var(--transition);
  &:hover { border-color: var(--border-strong); }
  &.active { background: var(--primary); color: #fff; border-color: var(--primary); }
  .draft-count { background: rgba(255,255,255,0.25); border-radius: 10px; padding: 0 6px; margin-left: 4px; font-size: 11px; }
}

.article-list { display: flex; flex-direction: column; gap: 10px; }
.empty-article { padding: 50px; text-align: center; color: var(--text-4); }
.article-item { padding: 14px 16px; transition: var(--transition); &:hover { border-color: var(--border-strong); } }
.article-header { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
.cat-tag { padding: 2px 8px; border-radius: var(--radius-sm); font-size: 12px; flex-shrink: 0; }
.c-selfHelp  { background: rgba(52,199,89,0.15);  color: #4cd964; }
.c-emotion   { background: rgba(175,82,222,0.18); color: #c08bff; }
.c-lowCal    { background: rgba(0,199,190,0.16);  color: #2fd0c4; }
.c-scienceEat{ background: rgba(255,149,0,0.16);  color: #ffb340; }
.article-header .title { font-size: 15px; color: var(--text-1); font-weight: 500; }

.article-info { display: flex; gap: 16px; color: var(--text-3); font-size: 12px; margin-bottom: 10px; span { display: inline-flex; align-items: center; gap: 4px; } }

.operate-btn { display: flex; justify-content: flex-end; align-items: center; gap: 6px; }
.mark { display: inline-flex; align-items: center; gap: 3px; font-size: 11px; padding: 2px 7px; border-radius: var(--radius-pill); }
.mark.hot { background: rgba(255,59,48,0.15); color: #ff6b61; }
.mark.essence { background: var(--bg-elevated); color: var(--text-2); }

/* 弹窗 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 1000; }
.modal {
  position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
  width: 600px; max-width: 92%; background: var(--bg-surface);
  border: 1px solid var(--border-strong); border-radius: var(--radius); z-index: 1001;
  &.small { width: 400px; }
  .modal-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid var(--border); h3 { margin: 0; color: var(--text-1); font-size: 16px; } }
  .modal-close { color: var(--text-3); cursor: pointer; display: inline-flex; &:hover { color: var(--primary); } }
  .modal-body { padding: 18px 20px; }
  .modal-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 14px 20px; border-top: 1px solid var(--border); }
}
.form-item { margin-bottom: 14px; label { display: block; margin-bottom: 6px; color: var(--text-3); font-size: 13px; } .input { width: 100%; } }
.confirm-text { color: var(--text-2); line-height: 1.6; text-align: center; padding: 6px 0; }

@media (max-width: 980px) {
  .content-wrap { flex-direction: column; }
  .left-panel { width: 100%; display: flex; gap: 16px; .cate-box, .hot-box { flex: 1; margin-bottom: 0; } }
}
</style>
