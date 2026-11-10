const express = require('express')
const KnowledgeRouter = express.Router()
const db = require('../db/index') // 导入你的数据库连接

// ===================== 1. 获取文章列表（对接articles表） =====================
KnowledgeRouter.get('/list', (req, res) => {
  const { cateId, status, keyword } = req.query
  
  // 基础SQL（查询articles表）
  let sql = `SELECT * FROM articles WHERE 1=1`
  const params = []

  // 分类筛选（匹配categories表的slug/name）
  if (cateId && cateId !== 'all') {
    // 先查分类表获取对应名称，再关联文章（兼容你的categories表）
    const cateMap = {
      'selfHelp': '自救指南',
      'emotion': '情绪调节',
      'lowCal': '低卡食谱',
      'scienceEat': '科学进食'
    }
    const cateName = cateMap[cateId]
    if (cateName) {
      sql += ` AND title LIKE ?`
      params.push(`%${cateName}%`) // 临时匹配，后续可加article_category关联字段
    }
  }

  // 关键词搜索（标题/摘要）
  if (keyword) {
    sql += ` AND (title LIKE ? OR summary LIKE ?)`
    params.push(`%${keyword}%`, `%${keyword}%`)
  }

  // 执行查询
  db.query(sql, params, (err, results) => {
    if (err) {
      return res.send({ code: 500, msg: '数据库查询失败', error: err.message })
    }

    // 格式化返回数据（适配前端字段）
    const articleList = results.map(item => ({
      id: item.id,
      title: item.title,
      cate: item.title.includes('自救') ? 'selfHelp' : 
            item.title.includes('情绪') ? 'emotion' : 
            item.title.includes('低卡') ? 'lowCal' : 'scienceEat',
      view: Math.floor(Math.random() * 10000).toString(), 
      comment: Math.floor(Math.random() * 1000), 
      date: '2026-03-04', 
      author: 'Admin_PC', 
      isHot: Math.random() > 0.5 ? 1 : 0, // 临时模拟热门
      isEssence: Math.random() > 0.5 ? 1 : 0, // 临时模拟精华
      status: 'published' // 后续可加status字段
    }))

    res.send({
      code: 200,
      msg: 'success',
      data: articleList
    })
  })
})



// ===================== 2. 获取热度排行（按标题关键词/模拟浏览量） =====================
KnowledgeRouter.get('/hot', (req, res) => {
  const sql = `SELECT id, title FROM articles LIMIT 5`
  
  db.query(sql, (err, results) => {
    if (err) {
      return res.send({ code: 500, msg: '获取热度排行失败', error: err.message })
    }

    const hotList = results.map(item => ({
      id: item.id,
      title: item.title
    }))

    res.send({
      code: 200,
      msg: 'success',
      data: hotList
    })
  })
})





// ===================== 3. 文章操作（删除/下架，对接真实数据库） =====================
KnowledgeRouter.post('/operate', (req, res) => {
  const { id, type } = req.body

  // 校验参数
  if (!id || !type) {
    return res.send({ code: 400, msg: '缺少id或操作类型' })
  }

  switch (type) {
    // 删除文章（物理删除，生产环境建议逻辑删除）
    case 'delete':
      const deleteSql = `DELETE FROM articles WHERE id = ?`
      db.query(deleteSql, [id], (err, results) => {
        if (err) {
          return res.send({ code: 500, msg: '删除失败', error: err.message })
        }
        if (results.affectedRows === 0) {
          return res.send({ code: 400, msg: '文章不存在' })
        }
        res.send({ code: 200, msg: '删除成功', data: true })
      })
      break

    // 下架文章（逻辑删除，需先给articles表加status字段）
    case 'offline':
      const offlineSql = `UPDATE articles SET status = 'offline' WHERE id = ?`
      db.query(offlineSql, [id], (err, results) => {
        if (err) {
          return res.send({ code: 500, msg: '下架失败', error: err.message })
        }
        if (results.affectedRows === 0) {
          return res.send({ code: 400, msg: '文章不存在' })
        }
        res.send({ code: 200, msg: '下架成功', data: true })
      })
      break

    // 设精/设热（需给articles表加is_hot/is_essence字段）
    case 'essence':
    case 'hot':
      const field = type === 'essence' ? 'is_essence' : 'is_hot'
      const toggleSql = `UPDATE articles SET ${field} = NOT ${field} WHERE id = ?`
      db.query(toggleSql, [id], (err, results) => {
        if (err) {
          return res.send({ code: 500, msg: '操作失败', error: err.message })
        }
        if (results.affectedRows === 0) {
          return res.send({ code: 400, msg: '文章不存在' })
        }
        res.send({ code: 200, msg: '操作成功', data: true })
      })
      break

    default:
      res.send({ code: 400, msg: '操作类型错误（仅支持delete/offline/essence/hot）' })
  }
})



// ===================== 4. 发布新文章（插入到articles表） =====================
KnowledgeRouter.post('/publish', (req, res) => {
  const { title, content, summary, cate } = req.body

  // 校验必填字段
  if (!title || !content) {
    return res.send({ code: 400, msg: '标题和内容不能为空' })
  }

  // 转换分类名称（适配你的categories表）
  const cateMap = {
    'selfHelp': '自救指南',
    'emotion': '情绪调节',
    'lowCal': '低卡食谱',
    'scienceEat': '科学进食'
  }
  const cateName = cateMap[cate] || '科学进食'

  // 插入SQL
  const insertSql = `INSERT INTO articles (title, content, summary, created_at) VALUES (?, ?, ?, NOW())`
  const params = [title, content, summary || title]

  db.query(insertSql, params, (err, results) => {
    if (err) {
      return res.send({ code: 500, msg: '发布失败', error: err.message })
    }

    res.send({
      code: 200,
      msg: '发布成功',
      data: {
        id: results.insertId,
        title,
        content,
        summary,
        cate
      }
    })
  })
})



// ===================== 5. 获取分类列表（对接categories表） =====================
KnowledgeRouter.get('/category', (req, res) => {
  const sql = `SELECT * FROM categories`
  
  db.query(sql, (err, results) => {
    if (err) {
      return res.send({ code: 500, msg: '获取分类失败', error: err.message })
    }

    // 格式化分类数据（适配前端）
    const cateList = results.map(item => ({
      id: item.id,
      name: item.name,
      slug: item.slug,
      sort: item.sort_order
    }))

    res.send({
      code: 200,
      msg: 'success',
      data: cateList
    })
  })
})



module.exports = KnowledgeRouter