const express = require('express');
const apiRoutes = require('./api/apiRoutes');

const app = express();
const PORT = 3000;

app.use('/api', apiRoutes);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
