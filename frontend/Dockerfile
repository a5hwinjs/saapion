# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Set NITRO_PRESET for the build
ENV NITRO_PRESET=node-server

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Build the Nuxt 3 application
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy the entire .output directory
COPY --from=builder /app/.output ./.output

# Fix Nitro path resolution bug: Symlink the public directory to where the server mistakenly looks for it
RUN mkdir -p /app/.output/server/chunks && ln -s /app/.output/public /app/.output/server/chunks/public

# Nuxt/Nitro environment variables
ENV PORT=3000
ENV HOST=0.0.0.0
ENV NODE_ENV=production
ENV NITRO_PRESET=node-server

EXPOSE 3000

# Start command
CMD ["node", ".output/server/index.mjs"]
