const express = require('express')
// 导入路由
const router = express.Router()
// 导入数据库
const db = require('../db/index')

// 书写后端接口

router.get('/gain',(req,res)=>{
    // let name = req.query.name
    // let type = req.query.type
    const sqlFindAll='select * from roles'
    // console.log(name,type)
    // const sql = "SELECT * FROM `roles` WHERE name=? AND `type`= ?"
    db.query(sqlFindAll, (err,resu) =>{
        if(err){
            console.error('查询角色列表失败：',err);
            return res.status(500).json({
                code:500,
                msg:'查询失败',
                data:err
            });
        }
        return res.status(200).json({
            code:200,
            msg:'查询成功',
            data:resu
        })
        // if(result.length === 0){
        //     return res.send({ 
                
        //     })
        // }
    })

})

router.delete('/deleteById/:id',(req,res)=>{
    // 获取参数params
    var msg = req.params
    // 书写sql
    const deleteMsg='delete from roles where id=?'
    db.query(deleteMsg,msg.id,(err,resu)=>{
        if(err){
            return res.send({
                code:500,
                msg:'网络有问题',
                data:''
            })
        }
        if(resu.affectedRows==0){
            return res.send({
                code:200,
                msg:'没有此员工',
                data:''
            })
        }else{
            return res.send({
                code:200,
                msg:'删除成功',
                data:resu
            })
        }
         
    })
})

router.post('/addroles',(req,res)=>{
    var roles = req.body
    // const addroles='insert into roles (name,type) values (?,?)'
    const addroles = 'INSERT INTO roles (name, type) VALUES (?, ?)';
    // db.query(addroles,[roles.name,roles.type],
    //     (err,resu)=>{
    //         res.send(resu)
    //     }
    // )
    db.query(addroles, [roles.name, roles.type], (err, resu) => {
        if (err) {
            console.error('插入失败:', err);
            return res.status(500).json({ code: 500, msg: '插入失败', data: err });
        }
        res.status(200).json({ code: 200, msg: '插入成功', data: resu });
    });
})
module.exports = router