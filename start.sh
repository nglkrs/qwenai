#!/bin/bash

# Start Ollama in background
echo "Starting Ollama..."
ollama serve &

# Wait for Ollama to start
sleep 10

# Pull the model (if not already present)
echo "Pulling Qwen model..."
ollama pull qwen:0.5b

# Start nginx
echo "Starting nginx..."
nginx -c /app/nginx.conf

# Keep the container running
tail -f /dev/null