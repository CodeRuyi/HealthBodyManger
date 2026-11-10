# HealthBodyManger · 猪瘾急救站 PC 管理后台

> 一个给「猪瘾」（暴食 / 饮食失控）人群做健康管理的后台系统。前端 Vue3，后端 Express + MySQL，本仓库把前后端和数据库一起收了，克隆下来就能跑。

> A management dashboard for people dealing with binge-eating ("猪瘾"). Vue 3 frontend + Express/MySQL backend. This repo bundles the frontend, the backend, **and the database dump** so you can run the whole thing after a clone.

---

## 这是个啥 / What is this

做这个项目是因为身边不少人被「嘴馋停不下来、情绪一上来就暴食」困扰，但市面上多是冷冰冰的卡路里计算器。我们想做的更像一个**陪伴式管理后台**：把用户、会员、营养师、科普内容、权限都管起来，运营和专家能在上面协同工作。

This started from a simple need: most diet apps are just cold calorie counters. We wanted a **management console** where operators, experts and dietitians can actually collaborate — manage users, members, content and permissions in one place.

功能模块 / Modules:

- **用户管理 User**：增删改查、分页、按用户名搜索、年龄段统计
- **会员管理 Member**：会员等级、费用、到期时间、状态策略
- **营养师管理 Dietitian**：营养师列表、排班日历、流水统计
- **科普内容 Knowledge**：文章发布 / 下架 / 设精设热 / 分类 / 热度排行
- **权限角色 Permission**：角色定义、权限点（JSON 存储）
- **数据看板 Dashboard**：首页聚合展示

---

## 技术栈 / Tech Stack

| 层 Layer | 技术 Tech |
| --- | --- |
| 前端 Frontend | Vue 3 · Vite 7 · Pinia · Vue Router · Axios · ECharts · Chart.js |
| 后端 Backend | Node.js · Express 5 · mysql2 · cors |
| 数据库 Database | MySQL 8（库名 `pig`） |

---

## 目录结构 / Project Structure

```
HealthBodyManger/
├── README.md              # 本文件（你正在看的就是它）
├── .gitignore
├── Manager/               # 后端 Backend (Express)
│   ├── index.js           # 服务入口，监听 8888
│   ├── db/
│   │   ├── index.js       # MySQL 连接池配置
│   │   ├── pig.sql        # ⭐ 数据库结构与真实数据（24 张表）
│   │   └── README.md      # 数据库详细说明
│   └── router/            # 各业务路由
│       ├── UserRouter.js
│       ├── RolesRouter.js
│       ├── NutritionistRouter.js
│       ├── KnowledgeRouter.js
│       ├── NianLing.js    # 遗留文件，未挂载
│       └── XingBie.js     # 遗留文件，未挂载
└── vue-pc端/              # 前端 Frontend (Vue3 + Vite)
    ├── index.html
    ├── vite.config.js
    ├── src/
    │   ├── api/request.js # 所有接口封装，baseURL = http://localhost:8888
    │   ├── views/         # 页面：登录/注册/用户/会员/营养师/科普/权限/看板
    │   ├── components/    # Icon、Toast 等
    │   ├── router/        # 前端路由
    │   ├── stores/        # Pinia
    │   └── assets/        # 样式与图标
    └── package.json
```

---

## 环境准备 / Prerequisites

- **Node.js** ≥ 20（前端 `package.json` 写了 `^20.19.0 || >=22.12.0`，后端 Express 5 也建议新版本）
- **MySQL 8** 本地跑着，账号 `root`、密码 `1234`（见 `Manager/db/index.js`）
- 包管理器 npm（yarn / pnpm 也行，只是没锁文件对应）

> 如果你的 MySQL 不是 `root / 1234`，改一下 `Manager/db/index.js` 里的连接配置即可。
> If your MySQL uses different credentials, just edit `Manager/db/index.js`.

---

## 三步跑起来 / Quick Start

### 1. 建数据库 / Database

```bash
# 建库
mysql -u root -p1234 -e "CREATE DATABASE IF NOT EXISTS pig CHARACTER SET utf8mb4;"

# 导入表结构 + 数据（就是这个仓库里的 pig.sql）
mysql -u root -p1234 pig < Manager/db/pig.sql
```

### 2. 启动后端 / Backend

```bash
cd Manager
npm install
npm start          # 实际是 node index.js，监听 http://localhost:8888
```

看到 `✅ Serve is running on http://localhost:8888` 就成功了。

### 3. 启动前端 / Frontend

```bash
cd vue-pc端
npm install
npm run dev        # Vite 开发服务器，默认 http://localhost:5173
```

浏览器打开 Vite 给的地址，默认会跳到 `/login`。

---

## 默认账号 / Default accounts

后台登录走 `sys_admin` 表，库里已经预置了几个账号：

| 用户名 Username | 说明 Role |
| --- | --- |
| `admin` | 系统超级管理员 |
| `dietitian1` | 营养师 |
| `operator1` | 运营 |

> 密码在 `sys_admin` 表里（都是 6 位），自己进去看一眼就行。注册接口 `/users/register` 也能现建账号。
> Passwords live in `sys_admin`; check the table directly, or just use the register endpoint.

---

## 接口速查 / API at a glance

后端根地址 `http://localhost:8888`：

| 模块 | 路径 | 说明 |
| --- | --- | --- |
| 用户 User | `/users/login` `/users/register` `/users/list` `/users/search` `/users/update/:id` `/users/delete/:id` `/users/age/stats` | 登录/注册/分页/搜索/改/删/年龄统计 |
| 会员 Member | `/users/member/list` `/users/member/update/:id` | 会员列表 / 策略更新 |
| 角色 Roles | `/roles/gain` `/roles/addroles` `/roles/deleteById/:id` | 角色查/增/删 |
| 营养师 Dietitian | `/nutritionists` `/nutritionists/duty/calendar` `/nutritionists/flow/data` `/nutritionists/export` | 列表 / 排班 / 流水 / 导出 |
| 科普 Knowledge | `/knowledge/list` `/knowledge/hot` `/knowledge/operate` `/knowledge/publish` `/knowledge/category` | 文章列表 / 热度 / 操作 / 发布 / 分类 |

详细字段和表结构见 [`Manager/db/README.md`](Manager/db/README.md)。

---

## 一些说明（避坑）/ Notes & known rough edges

- **连接信息是写死的**：`Manager/db/index.js` 里 `root / 1234` 是明文，纯本地 demo 方便，上生产请挪到环境变量。
- **部分数据是模拟的**：营养师排班日历、流水统计这两个接口目前是后端写死的演示数据，没查库，前端图表照样能渲染。
- **两个遗留路由文件**：`NianLing.js`、`XingBie.js` 是早期年龄/性别统计接口的草稿，没有被 `index.js` 挂载，实际不生效，留着当参考。
- **前端 `vue-pc端/README.md`** 是 Vite 脚手架自带的模板说明，真正的项目文档以本文件为准。

---

## License

个人项目，代码可自由学习和二次开发。数据库 `pig.sql` 里的数据均为演示用途，不含任何真实个人隐私信息。

Personal project — free to study and fork. The data in `pig.sql` is demo data with no real personal information.
