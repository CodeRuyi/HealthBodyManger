# 数据库说明 · Database

本项目的后端（Manager）连接的是一个叫 **`pig`** 的 MySQL 库（名字是项目早期随手起的，沿用至今）。

> The backend connects to a MySQL database named **`pig`** (yes, the name stuck from day one).

## 连接配置 / Connection

后端在 `Manager/db/index.js` 里写死了本地连接，跑之前请确认你的 MySQL 也是这套：

```js
const mysql = require('mysql2')
const db = mysql.createPool({
  host: '127.0.0.1',
  user: 'root',
  password: '1234',
  database: 'pig'
})
```

- 主机 Host：`127.0.0.1`
- 账号 User：`root`
- 密码 Password：`1234`
- 库名 Database：`pig`
- 端口 Port：`3306`（MySQL 默认）

> 密码是明文写死的，纯本地 demo 方便，上生产记得挪到环境变量里。
> Password is hard-coded for local dev convenience. Move it to an env var before any real deployment.

## 怎么把库建起来 / How to import

`pig.sql` 已经把**表结构 + 真实数据**都导出来了（24 张表，含用户、会员、营养师、科普文章等），克隆本项目后一条命令就能还原：

```bash
# 1. 先建一个空库（也可以直接让 mysql 导入时建）
mysql -u root -p1234 -e "CREATE DATABASE IF NOT EXISTS pig CHARACTER SET utf8mb4;"

# 2. 把结构和数据灌进去
mysql -u root -p1234 pig < Manager/db/pig.sql
```

导入完用 `USE pig; SHOW TABLES;` 验证一下，应该能看到下面这些表。

## 表一览 / Tables (24)

| 分类 Group | 表 Tables |
| --- | --- |
| 账号 / 权限 Accounts & Roles | `sys_admin`、`sys_user`、`sys_role`、`roles`、`users`、`pigappusers`、`user_profile` |
| 会员 Member | `member`、`member_set` |
| 营养师 Nutritionist | `nutritionists`、`dietitian`、`cal` |
| 科普文章 Knowledge | `articles`、`article`、`article_category`、`article_tags`、`article_versions`、`categories`、`science_articles`、`tags` |
| 统计 / 日志 Stats & Logs | `sys_stat`、`operation_logs` |

几张常用表的用途：

- **`sys_admin`**：后台登录账号（登录接口 `/users/login` 查的就是它）。
- **`sys_user`**：被管理的用户主体，含 `username / phone / gender / age / diet_status / status / tags / active_score`。
- **`roles`**：角色定义，`perms` 字段用 JSON 存权限点。
- **`member_set`**：会员策略表，含 `level / total_fee / expire_time / status`。
- **`nutritionists`**：营养师列表（前端营养师页直接 `SELECT *`）。
- **`articles`**：科普文章，`/knowledge/*` 系列接口围绕它转。

## 备注 / Notes

- 部分接口（如营养师排班日历 `/nutritionists/duty/calendar`、流水 `/nutritionists/flow/data`）目前是后端写死的模拟数据，没走数据库，属于演示用途。
- `Manager/router/` 下的 `NianLing.js`、`XingBie.js` 是早期统计接口的遗留文件，没有被 `index.js` 挂载，实际没生效，留着仅供参考。
