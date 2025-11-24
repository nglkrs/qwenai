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

# Copy ALL files first
COPY . .

# Install npm dependencies (if package.json exists)
RUN if [ -f "package.json" ]; then npm install; fi

# Make startup script executable
RUN chmod +x start.sh

# Expose ports
EXPOSE 3000
EXPOSE 11434

# Start everything
CMD ["./start.sh"]