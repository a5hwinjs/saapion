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

# Only copy the necessary output from the builder stage
COPY --from=builder /app/.output ./.output

# Nuxt output includes its own package.json if needed, but for node server
# it's usually self-contained in .output/server/index.mjs.
# However, Nitro needs the .output directory structure to be intact.

EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=production

# Start command for Nuxt 3 production server
CMD ["node", ".output/server/index.mjs"]
