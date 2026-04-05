FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Build the Nuxt 3 application
RUN npm run build

# Expose port (Railway provides $PORT)
EXPOSE 3000

# Start command for Nuxt 3 production server
CMD ["sh", "-c", "PORT=${PORT:-3000} node .output/server/index.mjs"]
