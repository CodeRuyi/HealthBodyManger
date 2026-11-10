const express = require('express')
// 导入路由
const router = express.Router()
// 导入数据库
const db = require('../db/index')

// 登录接口
// router.post('/login', (req, res) => {
//     const { username, password } = req.body
    
//     if (!username || !password) {
//         return res.status(400).json({
//             code: 400,
//             message: '用户名和密码不能为空'
//         })
//     }
    
//     const sql = "SELECT id, username, age, gender FROM sys_user WHERE username = ? AND password = ?"
    
//     db.query(sql, [username, password], (err, result) => {
//         if (err) {

//             console.error('数据库查询错误:', err)
//             return res.status(500).json({
//                 code: 500,
//                 message: '数据库查询失败',
//                 error: err.message
//             })
//         }
        
//         if (result.length === 0) {
//             return res.status(401).json({
//                 code: 401,
//                 message: '用户名或密码错误'
//             })
//         }
        
//         res.json({
//             code: 200,
//             message: '登录成功',
//             data: result[0]
//         })
//     })
// })

// 获取用户年龄分布统计接口
router.get('/age-distribution', (req, res) => {
    const sql = `
        
            SELECT 
    age_group,
    COUNT(*) as count
FROM (
    SELECT 
        CASE
            WHEN age < 18 THEN '0-18岁'
            WHEN age >= 18 AND age < 23 THEN '18-23岁'
            WHEN age >= 23 AND age < 28 THEN '23-28岁'
            WHEN age >= 28 AND age < 35 THEN '28-35岁'
            ELSE '35岁以上'
        END AS age_group
    FROM sys_user
    WHERE age IS NOT NULL
) AS temp_table
GROUP BY age_group
ORDER BY 
    CASE age_group
        WHEN '0-18岁' THEN 1
        WHEN '18-23岁' THEN 2
        WHEN '23-28岁' THEN 3
        WHEN '28-35岁' THEN 4
        ELSE 5
    END;
    `
    
    db.query(sql, (err, results) => {
        if (err) {
            console.log(err);
            
            console.error('数据库查询错误:', err)
            return res.status(500).json({
                code: 500,
                message: '数据库查询失败',
                error: err.message
            })
        }
        
        // 确保所有年龄段都有返回，即使数量为0
        const allAgeGroups = [
            { age_group: '0-18岁', count: 0 },
            { age_group: '18-23岁', count: 0 },
            { age_group: '23-28岁', count: 0 },
            { age_group: '28-35岁', count: 0 },
            { age_group: '35岁以上', count: 0 }
        ]
        
        // 用数据库查询结果填充
        results.forEach(dbRow => {
            const index = allAgeGroups.findIndex(item => item.age_group === dbRow.age_group)
            if (index !== -1) {
                allAgeGroups[index].count = dbRow.count
            }
        })
        
        res.json({
            code: 200,
            message: '获取年龄分布成功',
            data: allAgeGroups
        })
    })
})

module.exports = router