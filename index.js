const express = require('express');
const app = express();

const PORT = 80; // Change this to port 80

app.get('/', (req, res) => {
    res.send('Hello World!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
