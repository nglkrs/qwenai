// server.js - Create this file
const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.post('/api/chat', async (req, res) => {
    const { prompt } = req.body;
    
    // Call Ollama (this would need to be installed on Render)
    exec(`curl -s http://localhost:11434/api/generate -d '{
        "model": "qwen:0.5b",
        "prompt": "${prompt}",
        "stream": false
    }'`, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ error: error.message });
        }
        try {
            const data = JSON.parse(stdout);
            res.json(data);
        } catch (e) {
            res.status(500).json({ error: 'Invalid response from Ollama' });
        }
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});