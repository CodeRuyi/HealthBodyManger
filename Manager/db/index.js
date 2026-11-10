const mysql = require('mysql2')
const db = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '1234',
    database: 'pig'
})
module.exports = db