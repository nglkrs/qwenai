FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Create app directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./
RUN npm install

# Copy source code
COPY server.js .
COPY start.sh .
COPY public/ ./public/

# Make startup script executable
RUN chmod +x start.sh

# Expose ports (FIXED - no comments on same line)
EXPOSE 3000
EXPOSE 11434

# Start everything
CMD ["./start.sh"]