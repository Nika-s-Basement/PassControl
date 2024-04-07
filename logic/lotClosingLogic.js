const {Pool} = require('pg');

const pool = new Pool({
    connectionString: 'postgresql://your_username:your_password@localhost:5432/your_database',
});



const closeLots = async () => {
    const currentTime = new Date();
    const {rows} = await pool.query('SELECT * FROM lots WHERE active_until < $1 AND is_active = true', [currentTime]);
    for (const lot of rows) {
        const lotId = lot.lot_id;
        const {rows: bidRows} = await pool.query('SELECT * FROM bids WHERE lot_id = $1 ORDER BY amount DESC LIMIT 1', [lotId]);
        if (bidRows.length > 0) {
            const winningBid = bidRows[0];
            const winningUserId = winningBid.user_id;
            await pool.query('UPDATE lots SET is_active = false, winning_user_id = $1 WHERE lot_id = $2', [winningUserId, lotId]);
        } else {
            await pool.query('UPDATE lots SET is_active = false WHERE lot_id = $1', [lotId]);
        }
    }
};

module.exports = {closeLots};
