const express = require('express');
const apiRoutes = require('./api/apiRoutes');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(apiRoutes);


app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
