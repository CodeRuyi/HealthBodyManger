# vue-pc端 · 前端

这是 [HealthBodyManger](../../README.md) 的前端部分，基于 **Vue 3 + Vite 7**。

> Frontend of the HealthBodyManger project (Vue 3 + Vite). See the [root README](../../README.md) for the full picture, database setup, and default accounts.

## 本地启动 / Run locally

```bash
npm install
npm run dev      # 开发服务器，默认 http://localhost:5173
npm run build    # 产物输出到 dist/（已被 .gitignore 忽略）
```

## 要点 / Notes

- 所有后端请求封装在 `src/api/request.js`，`baseURL` 默认指向 `http://localhost:8888`（即 Manager 后端）。
- 后端没起的话页面能开但接口会挂，先按根目录 README 把后端跑起来。
- `dist/`、`node_modules/` 已忽略，不会进仓库。
