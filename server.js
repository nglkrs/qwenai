const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch'); // Better than exec + curl

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.post('/api/chat', async (req, res) => {
    const { prompt } = req.body;
    
    if (!prompt) {
        return res.status(400).json({ error: 'Prompt is required' });
    }

    try {
        const response = await fetch('http://localhost:11434/api/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'qwen:0.5b',
                prompt: prompt,
                stream: false
            })
        });

        if (!response.ok) {
            throw new Error(`Ollama API error: ${response.status}`);
        }

        const data = await response.json();
        res.json(data);
        
    } catch (error) {
        console.error('Error calling Ollama:', error);
        res.status(500).json({ 
            error: 'Failed to communicate with Ollama',
            details: error.message 
        });
    }
});

// Health check endpoint
app.get('/api/health', async (req, res) => {
    try {
        const response = await fetch('http://localhost:11434/api/tags');
        if (response.ok) {
            res.json({ status: 'healthy', ollama: 'connected' });
        } else {
            res.status(500).json({ status: 'unhealthy', ollama: 'disconnected' });
        }
    } catch (error) {
        res.status(500).json({ status: 'unhealthy', ollama: 'disconnected', error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Ollama proxy available at http://localhost:${PORT}/api/chat`);
});