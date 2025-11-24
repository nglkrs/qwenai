FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.ai/install.sh | sh

WORKDIR /app

COPY index.html .
COPY nginx.conf .
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 80
EXPOSE 11434

CMD ["./start.sh"]