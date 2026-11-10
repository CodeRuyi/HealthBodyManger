const express = require('express');
const router = express.Router();
const db = require('../db/index.js');

// ==========================
// 1. 营养师列表（主接口）
// ==========================
router.get('/', (req, res) => {
  const sql = 'SELECT * FROM nutritionists';
  db.query(sql, (err, result) => {
    if (err) {
      return res.send({ code: 500, message: '查询失败' });
    }
    res.send({ code: 200, data: result });
  });
});

// ==========================
// 2. 排班日历数据
// ==========================
router.post('/duty/calendar', (req, res) => {
  res.send({
    code: 200,
    data: [3,5,2,7,4,6,8,2,5,3,5,7,2,4,6,8,2,5,3,5,7,2,4,6,8,2,5,3,4,6,2]
  });
});

// ==========================
// 3. 流水统计数据
// ==========================
router.get('/flow/data', (req, res) => {
  res.send({
    code: 200,
    data: [
      { label: '核心专家', percent: 80, amount: 48 },
      { label: '高级营养师', percent: 65, amount: 32 },
      { label: '普通营养师', percent: 40, amount: 18 },
      { label: '新锐营养师', percent: 25, amount: 9 }
    ]
  });
});

// ==========================
// 4. 导出（模拟）
// ==========================
router.get('/export', (req, res) => {
  res.send({ code: 200, message: '导出成功' });
});

module.exports = router;