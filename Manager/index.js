const express = require('express');
const cors = require('cors');
const RolesRouter = require('./router/RolesRouter');
const userRouter = require('./router/UserRouter');
const NutritionistRouter = require('./router/NutritionistRouter');
// 新增：导入科普路由
const KnowledgeRouter = require('./router/KnowledgeRouter');

const serve = express();

serve.use(cors());
serve.use(express.json());

serve.use('/users', userRouter);
serve.use('/roles', RolesRouter);
serve.use('/nutritionists', NutritionistRouter);
// 新增：注册科普路由
serve.use('/knowledge', KnowledgeRouter);

serve.listen(8888, () => {
  console.log('✅ Serve is running on http://localhost:8888');
});