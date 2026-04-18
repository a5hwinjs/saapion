# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy application code (ignoring what's in .dockerignore)
COPY . .

# Build the Nuxt 3 application
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy the entire .output directory which contains both /server and /public
COPY --from=builder /app/.output ./.output

# Nuxt/Nitro environment variables
ENV PORT=3000
ENV HOST=0.0.0.0
ENV NODE_ENV=production

EXPOSE 3000

# Use the bundled server entry point
CMD ["node", ".output/server/index.mjs"]
