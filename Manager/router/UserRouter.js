const express = require('express')
const router = express.Router()
const db = require('../db/index.js')

// 书写后端的接口
// 1.登录信息的接口
router.get('/login', (req, res) => {
  const { username, password } = req.query

const sql = 'SELECT * FROM sys_admin WHERE username = ? AND password = ?'
  db.query(sql, [username, password], (err, result) => {
    // 1. 先判断 SQL 是否执行成功
    if (err) {
      return res.send({
        code: 500,
        message: '数据库查询失败',
        error: err.message
      })
    }

    // 2. 再判断是否查到了用户
    if (!result || result.length === 0) {
      return res.send({
        code: 400,
        message: '用户名或密码错误'
      })
    }

    // 3. 查询成功，返回用户信息
    res.send({
      code: 200,
      message: '登录成功',
      data: result[0]
    })
  })
})

router.post("/register", (req, res) => {
  const { username, password } = req.body;

  // 1. 先查用户名是否已存在
  const checkSql = "SELECT * FROM sys_admin WHERE username = ?";
  db.query(checkSql, [username], (err, result) => {
    if (err) {
      return res.send({ code: 500, message: "服务器错误" });
    }
    if (result.length > 0) {
      return res.send({ code: 400, message: "用户名已存在" });
    }

    // 2. 不存在 → 插入数据库
    const insertSql = "INSERT INTO sys_admin (username, password) VALUES (?, ?)";
    db.query(insertSql, [username, password], (err) => {
      if (err) {
        return res.send({ code: 500, message: "注册失败" });
      }
      res.send({ code: 200, message: "注册成功" });
    });
  });
});

// 2.
// 修改用户信息
// 更新用户信息
router.post('/update/:id', (req, res) => {
  const { id } = req.params;
  const { username, phone, gender, age, diet_status, status, tags, active_score } = req.body;

  const updateSql = `
    UPDATE sys_user 
    SET username = ?, phone = ?, gender = ?, age = ?, 
        diet_status = ?, status = ?, tags = ?, active_score = ?
    WHERE id = ?
  `;

  db.query(updateSql, [username, phone, gender, age, diet_status, status, tags, active_score, id], (err, result) => {
    if (err) {
      return res.status(500).json({ code: 500, msg: '更新用户失败', error: err.message });
    }
    res.json({ code: 200, msg: '更新成功' });
  });
});





// 用户名精准查询用户接口（POST /users/search）
router.post('/search', (req, res) => {
  // 1. 获取前端传的用户名参数（Query参数）
  const username = req.query.username;

  // 2. 前置校验：用户名不能为空
  if (!username || username.trim() === '') {
    return res.send({ 
      code: 400, 
      msg: '请输入要查询的用户名' 
    });
  }

  // 3. 精准查询SQL（严格匹配username字段）
  const sql = 'SELECT * FROM sys_user WHERE username = ?';
  const params = [username.trim()]; // 去除首尾空格，避免匹配错误

  // 4. 执行SQL并返回结果
  db.query(sql, params, (err, result) => {
    if (err) {
      console.error('用户名查询失败：', err);
      return res.send({ 
        code: 500, 
        msg: '查询失败', 
        error: err.message 
      });
    }

    // 5. 结果处理：找到返回用户，没找到返回空
    if (result.length === 0) {
      return res.send({ 
        code: 200, 
        msg: '未找到该用户名对应的用户', 
        data: [] 
      });
    }
    res.send({ 
      code: 200, 
      msg: '查询成功', 
      data: [result[0]]// 精准查询返回单个用户对象
    });
  });
});



// 4.重置功能9
router.post('/reset', (req, res) => {
  const sql = "SELECT * FROM sys_user";

  db.query(sql, (err, result) => {
    if (err) {
      return res.send({ code: 500, msg: "重置失败" });
    }
    res.send({ code: 200, data: result });
  });
});




// 5.分页获取用户的信息并进行遍历
// 分页获取用户列表
// 只分页查询用户列表（纯SQL语句）
router.post('/list', (req, res) => {
  
  const page = req.body.page || 1;
  const size = 10; // 固定每页5条
  const offset = (page - 1) * size;

  // 获取总的用户信息条数
  const countSql = `SELECT COUNT(*) AS total FROM sys_user`;

  db.query(countSql, (err, countResult) => {
    if (err) {
      return res.status(500).json({ code: 500, msg: "查询总数失败" });
    }

    const total = countResult[0].total;

    // ======================
    // 2. 查询当前页数据 SQL
    // ======================
    const dataSql = `
      SELECT * FROM sys_user
      ORDER BY id DESC
      LIMIT ${size} OFFSET ${offset}
    `;

    db.query(dataSql, (err, dataResult) => {
      if (err) {
        return res.status(500).json({ code: 500, msg: "查询数据失败" });
      }

      // 返回分页数据
      res.json({
        code: 200,
        msg: "查询成功",
        data: {
          list: dataResult,
          total: total,
          page: page,
          size: size
        }
      });
    });
  });
});


// 6.后端管理员删除用户信息
router.post("/delete/:id", (req, res) => {
  const id = req.params.id;

  const sql = "DELETE FROM sys_user WHERE id = ?";

  db.query(sql, [id], (err, result) => {
    if (err) {
      res.send({
        code: 500,
        message: "删除失败",
      });
      return;
    }

    res.send({
      code: 200,
      message: "删除成功",
    });
  });
});


//7.对 会员用户信息的获取
// 会员信息的获取（列表）
router.get("/member/list", (req, res) => {
  // 补充 level、total_fee、expire_time 字段，用 AS 设置默认值
  const sql = `
    SELECT 
      id, 
      username, 
      phone, 
      total_fee,
      level,
      expire_time,
      status
    FROM member_set
  `;

  db.query(sql, (err, result) => {
    if (err) {
      return res.send({
        code: 500,
        message: "获取会员列表失败",
        error: err.message
      });
    }

    res.send({
      code: 200,
      message: "获取会员列表成功",
      data: result // 这里的 data 就是从数据库拿到的数组
    });
  });
});




// 8.管理员新增：更新会员策略接口（修改数据库）
router.put('/member/update/:id', (req, res) => {
  // 接收前端传的会员ID和修改后的数据
  const memberId = req.params.id
  const { username, level, total_fee, expire_time, status } = req.body
  const sql = `
    UPDATE member_set
    SET username=?, level=?, total_fee=?, expire_time=?, status=?
    WHERE id=?
  `

  db.query(sql, [username, level, total_fee, expire_time, status, memberId], (err, result) => {
    if (err) return res.send({ code: 500, message: '更新失败', error: err.message })
    if (result.affectedRows === 0) {
      return res.send({ code: 404, message: '会员不存在，更新失败' })
    }
    res.send({ code: 200, message: '策略更新成功' })
  })
})



// 注册功能的书写
// 注册接口



// 按年龄段统计用户数量接口（清晰易懂版）
router.get('/age/stats',  (req, res) => {

  // ==========================================
  // 第一步：定义固定的 5 个年龄段（前端图表必须用）
  // ==========================================
  const ageRanges = [
    '18岁以下',
    '18-25岁',
    '26-30岁',
    '31-40岁',
    '40岁以上'
  ];

  // ==========================================
  // 第二步：写简单易懂的 SQL，统计每个年龄段人数
  // ==========================================
  const sql = `
    SELECT
      CASE
        WHEN age < 18 THEN '18岁以下'
        WHEN age BETWEEN 18 AND 25 THEN '18-25岁'
        WHEN age BETWEEN 26 AND 30 THEN '26-30岁'
        WHEN age BETWEEN 31 AND 40 THEN '31-40岁'
        ELSE '40岁以上'
      END AS age_range,
      COUNT(*) AS count
    FROM sys_user
    WHERE age IS NOT NULL
    GROUP BY age_range
  `;

  // ==========================================
  // 第三步：执行 SQL 查询
  // ==========================================
  db.query(sql, (err, results) => {
    // 如果出错，直接返回错误信息
    if (err) {
      return res.send({ code: 500, message: "查询失败" });
    }

    // ==========================================
    // 第四步：把数据库查到的数据 → 转成方便查找的格式
    // ==========================================
    const countMap = {};
    results.forEach(item => {
      countMap[item.age_range] = item.count;
    });

    // ==========================================
    // 第五步：组装最终数据（保证 5 条都存在，缺的补 0）
    // ==========================================
    const finalData = ageRanges.map(range => {
      return {
        age_range: range,
        count: countMap[range] || 0
      };
    });

    // ==========================================
    // 第六步：返回给前端（格式完全匹配）
    // ==========================================
    res.send({
      code: 200,
      message: "统计成功",
      data: finalData
    });
  });
});

module.exports = router

