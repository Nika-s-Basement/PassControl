const express = require('express');
const bodyParser = require('body-parser');
const {Pool} = require('pg');

const pool = new Pool({
    user: 'your_username',
    host: 'localhost',
    database: 'your_database',
    password: 'your_password',
    port: 5432,
});

const router = express.Router();
router.use(bodyParser.json());

router.get('/lots', async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lots');
    res.json(rows);
});

router.post('/lots', async (req, res) => {
    const {title, description, initial_price, current_price, user_id} = req.body;
    const {rows} = await pool.query('INSERT INTO lots (title, description, initial_price, current_price, user_id) VALUES ($1, $2, $3, $4, $5) RETURNING *', [title, description, initial_price, current_price, user_id]);
    res.json(rows[0]);
});

router.get('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {rows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1', [lot_id]);
    res.json(rows);
});

router.post('/lots/:lot_id/bids', async (req, res) => {
    const {lot_id} = req.params;
    const {amount, user_id} = req.body;
    const {rows} = await pool.query('INSERT INTO bids (amount, lot_id, user_id) VALUES ($1, $2, $3) RETURNING *', [amount, lot_id, user_id]);
    res.json(rows[0]);
});

module.exports = router;
