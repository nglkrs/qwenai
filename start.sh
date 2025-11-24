#!/bin/bash

# Start Ollama in background
echo "Starting Ollama..."
ollama serve &

# Wait for Ollama to start
sleep 10

# Pull the model
echo "Pulling Qwen model..."
ollama pull qwen:0.5b

# Start Node.js server
echo "Starting Node.js server..."
node server.js