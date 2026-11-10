const express = require('express')
// 导入路由
const router = express.Router()
// 导入数据库
const db = require('../db/index')
router.get('/gender-distribution', (req, res) => {
    const sql = `
       SELECT 
    gender_group,
    COUNT(*) as count
FROM (
    SELECT 
        CASE
            WHEN gender = '男' OR gender = 'male' OR gender = 'M' THEN '男性'
            WHEN gender = '女' OR gender = 'female' OR gender = 'F' THEN '女性'
            ELSE '其他'
        END as gender_group
    FROM sys_user
    WHERE gender IS NOT NULL AND gender != ''
) AS temp_table
GROUP BY gender_group
ORDER BY 
    CASE gender_group
        WHEN '男性' THEN 1
        WHEN '女性' THEN 2
        ELSE 3
    END;
    `
    
    db.query(sql, (err, results) => {
        if (err) {
            console.error('数据库查询错误:', err)
            return res.status(500).json({
                code: 500,
                message: '数据库查询失败',
                error: err.message
            })
        }
        
        // 确保所有性别分类都有返回，即使数量为0
        const allGenderGroups = [
            { gender_group: '男性', count: 0 },
            { gender_group: '女性', count: 0 },
            { gender_group: '其他', count: 0 }
        ]
        
        // 用数据库查询结果填充
        results.forEach(dbRow => {
            const index = allGenderGroups.findIndex(item => item.gender_group === dbRow.gender_group)
            if (index !== -1) {
                allGenderGroups[index].count = dbRow.count
            }
        })
        
        res.json({
            code: 200,
            message: '获取性别分布成功',
            data: allGenderGroups
        })
    })
})

module.exports = router
