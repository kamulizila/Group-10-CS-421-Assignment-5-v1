# ---------- Build stage ----------
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only the package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the Vue app for production
RUN npm run build


# ---------- Production stage ----------
FROM nginx:alpine

# Remove default nginx static assets (optional but clean)
RUN rm -rf /usr/share/nginx/html/*

# Copy built Vue app from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
