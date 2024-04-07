const express = require('express');
const apiRoutes = require('./api/apiRoutes');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(apiRoutes);

// Использование CORS для всех запросов
app.use(cors());

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
