import axios from 'axios';
const instance = axios.create({
    baseURL:'http://localhost:8888'
})
// 1.晶晶的角色接口
export const getRoles = (params) => instance.get('/roles/gain', { params })
export const addRole = (data) => instance.post('/roles/addroles', data)
export const deleteRole = (id) => instance.delete(`/roles/deleteById/${id}`) 



// 1.登录接口
export const login = (username,password) =>{
    return instance.get('/users/login',{
        params:{ username, password}}
        
    )
}

// 1. 搜索用户
export const searchUserByUsername = (username) => {
  // POST请求，参数通过Query传递（和后端req.query.username对应）
  return instance.post('/users/search', {}, {
    params: { username } // 传递用户名参数
  })
}

// 2. 重置/获取全部用户
export const resetUser = () => {
  return instance.post('/users/reset');
};

// 3. 修改用户信息
// 更新用户信息
export const updateUser = (id, userData) => {
  return instance.post(`/users/update/${id}`, userData);
};

// 4.获取全部的用户信息的接口
export const getUserList = (page = 1, size = 5) => {
  return instance.post('/users/list', {
    page: page,
    size: size
  });
};

// 5.删除用户信息的接口
export const deleteUser = (id) => {
  return instance.post(`/users/delete/${id}`);
};


// 6.会员等级修改的接口
export const getMemberList = () => {
  return instance.get('/users/member/list')
}


// request.js
export const updateMemberStrategy = (memberData) => {
  return instance.put(`/users/member/update/${memberData.id}`, memberData)
}

// 注册功能的接口
export const register = (data) =>{
  return instance.post('/users/register',data)
}
// request.js 中追加：

// 7. 按年龄段统计用户数量的接口
export const getAgeStats = () => {
  return instance.get('/users/age/stats');
};


// 营养师
export const getNutritionists = () => instance.get("/nutritionists");

// 日历
export const getDutyCalendar = () => instance.post("/nutritionists/duty/calendar");

// 流水
export const getFlowData = () => instance.get("/nutritionists/flow/data");

// 导出
export const exportNutritionists = () => instance.get("/nutritionists/export");


export const getKnowledgeList = (params) => instance.get('/knowledge/list', { params })

// 2. 获取热度排行
export const getKnowledgeHot = () => instance.get('/knowledge/hot')

// 3. 文章操作（删除/下架/设精/设热）
export const operateKnowledge = (data) => instance.post('/knowledge/operate', data)

// 4. 发布新文章
export const publishKnowledge = (data) => instance.post('/knowledge/publish', data)

// 5. 获取分类列表（新增，对接categories表）
export const getKnowledgeCate = () => instance.get('/knowledge/category')
