const express = require('express');
const app = express();
const port = 5000;

// Định nghĩa route cho đường dẫn gốc '/'
app.get('/', (req, res) => {
    res.send('Welcome to the Node.js server!');
});

// API endpoint đơn giản
app.get('/api', (req, res) => {
    res.json({ message: 'Hello from Node.js server!' });
});

// Chạy server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
