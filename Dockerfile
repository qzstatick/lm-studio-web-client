# Multi-stage build for smaller final image
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first for better layer caching
COPY package.json package-lock.json* ./

# Install production dependencies only
RUN npm ci --omit=dev || npm install

# Copy application source code
COPY . .

# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

EXPOSE 5000

USER appuser

CMD ["npm", "start"]