const express = require('express');
const bodyParser = require('body-parser');

const {closeLots} = require('../logic/lotClosingLogic.js');
const cors = require("cors");
const path = require("path");
const { POOL } = require("../config");

const pool = POOL


const router = express.Router();
router.use(bodyParser.json());

// Регистрация новых пользователей
router.post('/register', cors(), async (req, res) => {
    const {username, password, email} = req.body;
    const existingUser = await pool.query('SELECT * FROM users WHERE username = $1 OR email = $2', [username, email]);
    if (existingUser.rows.length > 0) {
        res.status(400).json({error: 'User with the same username or email already exists'});
    } else {
        const {rows} = await pool.query('INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING *', [username, password, email]);
        res.json(rows[0]);
    }
    logging(req, path);
});

// Логин пользователя
router.post('/login', cors(), async (req, res) => {
    const {username, password} = req.body;
    const {rows} = await pool.query('SELECT * FROM users WHERE username = $1 AND password = $2', [username, password]);
    if (rows.length > 0) {
        res.json({message: 'Login successful'});
    } else {
        res.status(401).json({message: 'Login failed'});
    }
    logging(req, path);
});

// Получение всех лотов
router.get('/lots', cors(), async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots');
    logging(req, path);
    res.json(rows);
});

// Получение активных лотов
router.get('/lots/active', cors(), async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = true');
    logging(req, path);
    res.json(rows);
});

// Получение архивированных лотов
router.get('/lots/archived', cors(), async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = false');
    logging(req, path);
    res.json(rows);
});

// Получение лота по его id
router.get('/lots/:id', cors(), async (req, res) => {
    const lotId = req.params.id;
    const {rows} = await pool.query('SELECT * FROM lots WHERE lot_id = $1', [lotId]);

    if (rows.length === 0) {
        return res.status(404).json({error: 'Lot not found'});
    }

    logging(req, path);
    res.json(rows[0]);
});

// Добавить новый лот
router.post('/lots', cors(), async (req, res) => {
    const {title, description, initial_price, current_price, user_id, category, active_until} = req.body;
    const categoryImageMap = {
        'real_estate': 'media/real_estate.jpg',
        'transport': 'media/transport.jpg',
        'electronics': 'media/electronics.jpg',
        'furniture': 'media/furniture.jpg',
        'misc': 'media/misc.jpg'
    };
    const categoryImage = categoryImageMap[category] || 'media/default.jpg';
    const {rows} = await pool.query('INSERT INTO lots (title, description, initial_price, current_price, user_id, category, image_url, active_until) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *', [title, description, initial_price, current_price, user_id, category, categoryImage, active_until]);
    logging(req, path);
    res.json(rows[0]);
});

// Удалить лот по его id
router.delete('/lots/:id', cors(), async (req, res) => {
    const lotId = req.params.id;
    const checkLotQuery = 'SELECT * FROM lots WHERE lot_id = $1';
    const {rows: checkLotRows} = await pool.query(checkLotQuery, [lotId]);
    if (checkLotRows.length === 0) {
        return res.status(404).json({error: 'Lot not found'});
    }
    const deleteLotQuery = 'DELETE FROM lots WHERE lot_id = $1 RETURNING *';
    const {rows: deletedLotRows} = await pool.query(deleteLotQuery, [lotId]);
    logging(req, path);
    res.json(deletedLotRows[0]);
});


// Получить все ставки на определённый лот
router.get('/lots/:lot_id/bids', cors(), async (req, res) => {
    const {lot_id} = req.params;
    const {rows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1', [lot_id]);
    logging(req, path);
    res.json(rows);
});

// Разместить ставку на лот
router.post('/lots/:lot_id/bids', cors(), async (req, res) => {
    const {lot_id} = req.params;
    const {amount, user_id} = req.body;
    const {rows} = await pool.query('INSERT INTO bids (amount, lot_id, user_id) VALUES ($1, $2, $3) RETURNING *', [amount, lot_id, user_id]);
    logging(req, path);
    res.json(rows[0]);
});

setInterval(async () => {
    await closeLots();
}, 60000);

const cheat = async () => {
    const {rows} = await pool.query('SELECT * FROM lots');
};

function logging(req, route) {
    const now = new Date();
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    console.log(`[${now.toLocaleString()}, IP: ${ip}] - ${route.connectionString}]`);
}

setInterval(async () => {
    await cheat();
}, 299000);

module.exports = router;
