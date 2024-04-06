const express = require('express');
const bodyParser = require('body-parser');
const {Pool} = require('pg');

const {closeLots} = require('../logic/lotClosingLogic.js');

const pool = new Pool({
    connectionString: 'postgresql://your_username:your_password@localhost:5432/your_database',
});

const router = express.Router();
router.use(bodyParser.json());

// Регистрация новых пользователей
router.post('/register', async (req, res) => {
    const {username, password, email} = req.body;
    const existingUser = await pool.query('SELECT * FROM users WHERE username = $1 OR email = $2', [username, email]);
    if (existingUser.rows.length > 0) {
        res.status(400).json({error: 'User with the same username or email already exists'});
    } else {
        const {rows} = await pool.query('INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING *', [username, password, email]);
        res.json(rows[0]);
    }
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
router.get('/lots/active', async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = true');
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

    // Проверка на авторизацию пользователя (пример)
    if (!user_id) {
        res.status(403).json({error: 'User not authorized to create lot'});
    } else {
        // Проверка на существование лота с таким же названием
        const existingLot = await pool.query('SELECT * FROM lots WHERE title = $1', [title]);
        if (existingLot.rows.length > 0) {
            res.status(400).json({error: 'Lot with the same title already exists'});
        } else {
            const {rows} = await pool.query('INSERT INTO lots (title, description, initial_price, current_price, user_id, category, active_until) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *', [title, description, initial_price, current_price, user_id, category, active_until]);
            res.json(rows);
        }
    }
});

// Получить все ставки на определённый лот
router.get('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {rows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1', [lot_id]);
    if (rows.length === 0) {
        res.status(404).json({error: 'Bids not found for this lot'});
    } else {
        res.json(rows);
    }
});

// Разместить ставку на лот
router.post('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {amount, user_id} = req.body;
    if (!user_id) {
        res.status(403).json({error: 'User not authorized to place bid'});
    } else {
        const {rows} = await pool.query('INSERT INTO bids (amount, lot_id, user_id) VALUES ($1, $2, $3) RETURNING *', [amount, lot_id, user_id]);
        res.json(rows[0]);
    }
});

setInterval(async () => {
    await closeLots();
}, 60000);

module.exports = router;
