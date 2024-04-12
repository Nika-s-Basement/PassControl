const express = require('express');
const bodyParser = require('body-parser');
const cors = require("cors");
const {Pool} = require("pg");
const rateLimit = require("express-rate-limit");

const {closeLots} = require('../logic/lotClosingLogic.js');
const path = require("path");
const pool = new Pool({
    connectionString: 'your_db',
});

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
});

const router = express.Router();
router.use(limiter);
router.use(bodyParser.json());

function logging(req, route) {
    const now = new Date();
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    console.log(`[${now.toLocaleString()}, IP: ${ip}] - ${route.connectionString}]`);
}

// Регистрация новых пользователей
router.post('/register', cors(), async (req, res) => {
    const {username, password, email} = req.body;
    try {
        const existingUser = await pool.query('SELECT * FROM users WHERE username = $1 OR email = $2', [username, email]);
        if (existingUser.rows.length > 0) {
            return res.status(400).json({error: 'User with the same username or email already exists'});
        }
        const {rows} = await pool.query('INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING *', [username, password, email]);
        res.json(rows[0]);
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Логин пользователя
router.post('/login', cors(), async (req, res) => {
    const {username, password} = req.body;
    try {
        const {rows} = await pool.query('SELECT * FROM users WHERE username = $1 AND password = $2', [username, password]);
        if (rows.length > 0) {
            res.json({message: 'Login successful', id: rows[0].id});
        } else {
            res.status(401).json({message: 'Login failed'});
        }
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получить id пользователя
router.get('/user/:username', cors(), async (req, res) => {
    const username = req.params.username;
    try {
        const {rows} = await pool.query('SELECT user_id FROM users WHERE username = $1', [username]);
        res.json(rows);
    } catch (error) {
        console.error('Error fetching user id:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получение всех лотов
router.get('/lots', cors(), async (req, res) => {
    try {
        const {rows} = await pool.query('SELECT * FROM lots');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching lots:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получение лотов пользователя по id
router.get('/lots/user/:id', cors(), async (req, res) => {
    const userId = req.params.id;
    try {
        const {rows} = await pool.query('SELECT * FROM lots WHERE user_id = $1', [userId]);
        res.json(rows);
    } catch (error) {
        console.error('Error fetching user lots:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получение активных лотов
router.get('/lots/active', cors(), async (req, res) => {
    try {
        const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = true');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching active lots:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получение архивированных лотов
router.get('/lots/archived', cors(), async (req, res) => {
    try {
        const {rows} = await pool.query('SELECT * FROM lots WHERE is_active = false');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching archived lots:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получение лота по его id
router.get('/lots/:id', cors(), async (req, res) => {
    const lotId = req.params.id;
    try {
        const {rows} = await pool.query('SELECT * FROM lots WHERE lot_id = $1', [lotId]);
        if (rows.length === 0) {
            return res.status(404).json({error: 'Lot not found'});
        }
        res.json(rows[0]);
    } catch (error) {
        console.error('Error fetching lot by id:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
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
    try {
        const {rows} = await pool.query('INSERT INTO lots (title, description, initial_price, current_price, user_id, category, image_url, active_until) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *', [title, description, initial_price, current_price, user_id, category, categoryImage, active_until]);
        res.json(rows[0]);
    } catch (error) {
        console.error('Error adding new lot:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Удалить лот по его id
router.delete('/lots/:id', cors(), async (req, res) => {
    const lotId = req.params.id;
    try {
        const checkLotQuery = 'SELECT * FROM lots WHERE lot_id = $1';
        const {rows: checkLotRows} = await pool.query(checkLotQuery, [lotId]);
        if (checkLotRows.length === 0) {
            return res.status(404).json({error: 'Lot not found'});
        }
        const deleteLotQuery = 'DELETE FROM lots WHERE lot_id = $1 RETURNING *';
        const {rows: deletedLotRows} = await pool.query(deleteLotQuery, [lotId]);
        res.json(deletedLotRows[0]);
    } catch (error) {
        console.error('Error deleting lot:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Получить все ставки на определённый лот
router.get('/lots/:lot_id/bids', cors(), async (req, res) => {
    const {lot_id} = req.params;
    try {
        const {rows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1', [lot_id]);
        res.json(rows);
    } catch (error) {
        console.error('Error fetching bids for lot:', error);
        res.status(500).json({error: 'Internal server error'});
    }
    logging(req, path);
});

// Разместить ставку на лот и обновить текущую цену лота
router.post('/lots/:lot_id/bids', cors(), async (req, res) => {
    const { lot_id } = req.params;
    const { amount, user_id } = req.body;
    try {
        await pool.query('BEGIN');
        const bidInsertResult = await pool.query('INSERT INTO bids (amount, lot_id, user_id) VALUES ($1, $2, $3) RETURNING *', [amount, lot_id, user_id]);
        const lotUpdateResult = await pool.query('UPDATE lots SET current_price = $1 WHERE lot_id = $2 RETURNING *', [amount, lot_id]);
        if (lotUpdateResult.rows.length === 0) {
            await pool.query('ROLLBACK');
            return res.status(404).json({ error: 'Lot not found or current price update failed' });
        }
        await pool.query('COMMIT');
        res.json({
            bid: bidInsertResult.rows[0],
            lot: lotUpdateResult.rows[0]
        });
    } catch (error) {
        await pool.query('ROLLBACK');
        console.error('Error placing bid on lot:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
    logging(req, path);
});


// Функция проверки состояния и закрытия лота
setInterval(async () => {
    try {
        await closeLots();
    } catch (error) {
        console.error('Error during lot closing:', error);
    }
}, 60000);

// Поддержание состояния подключения к БД
const cheat = async () => {
    try {
        await pool.query('SELECT * FROM lots');
    } catch (error) {
        console.error('Error keeping DB connection alive:', error);
    }
};

setInterval(async () => {
    await cheat();
}, 299000);

module.exports = router;
