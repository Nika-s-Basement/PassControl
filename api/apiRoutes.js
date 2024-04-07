const express = require('express');
const bodyParser = require('body-parser');
const {Pool} = require('pg');

const {closeLots} = require('../logic/lotClosingLogic.js');
const cors = require("cors");

const pool = new Pool({
    connectionString: 'postgresql://your_username:your_password@localhost:5432/your_database',
});


const router = express.Router();
router.use(bodyParser.json());

// Регистрация новых пользователей
router.post('/register', async (req, res) => {
    const {username, password, email} = req.body;
    const {rows} = await pool.query('INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING *', [username, password, email]);
    res.json(rows[0]);
});

// Логин пользователя
router.post('/login', async (req, res) => {
    const {username, password} = req.body;
    const {rows} = await pool.query('SELECT * FROM users WHERE username = $1 AND password = $2', [username, password]);
    if (rows.length > 0) {
        res.json({message: 'Login successful'});
    } else {
        res.status(401).json({message: 'Login failed'});
    }
});

// Получение всех лотов
router.get('/lots', async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots');
    res.json(rows);
});

// Получение активных лотов
router.get('/lots/active', cors(), async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = true');
    const now = new Date();
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    console.log(`Дата и время: ${now.toLocaleString()}, IP: ${ip}`);
    res.json(rows);
});

// Получение архивированных лотов
router.get('/lots/archived', async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = false');
    res.json(rows);
});

// Добавить новый лот
router.post('/lots', async (req, res) => {
    const {title, description, initial_price, current_price, user_id, category, active_until} = req.body;
    const {rows} = await pool.query('INSERT INTO lots (title, description, initial_price, current_price, user_id, category, active_until) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *', [title, description, initial_price, current_price, user_id, category, active_until]);
    res.json(rows[0]);
});

// Получить все ставки на определённый лот
router.get('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {rows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1', [lot_id]);
    res.json(rows);
});

// Разместить ставку на лот
router.post('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {amount, user_id} = req.body;
    const {rows} = await pool.query('INSERT INTO bids (amount, lot_id, user_id) VALUES ($1, $2, $3) RETURNING *', [amount, lot_id, user_id]);
    res.json(rows[0]);
});

setInterval(async () => {
    await closeLots();
}, 60000);

const cheat = async () => {
    const {rows} = await pool.query('SELECT * FROM lots');
};

setInterval(async () => {
    await cheat();
}, 4700);

module.exports = router;
