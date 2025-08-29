# ---------- BUILD STAGE ----------
FROM node:lts-slim AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies including dev
RUN npm ci

# Copy source code
COPY . .

# Build the NestJS application
RUN npm run build

# ---------- PRODUCTION STAGE ----------
FROM node:lts-slim AS production

WORKDIR /app

# Copy only production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built application from builder
COPY --from=builder /app/dist ./dist

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "dist/main.js"]
