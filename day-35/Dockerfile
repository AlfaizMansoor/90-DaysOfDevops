# this is test dockerfile for day-35
# Stage 1: Builder
FROM node:18-alpine AS builder
WORKDIR /src

COPY package*.json ./
RUN npm install --production
COPY . .

# Stage 2: Runtime
FROM node:18-alpine
WORKDIR /app

RUN adduser -S appuser && chown -R appuser /app

COPY --from=builder /src .

USER appuser
EXPOSE 3000
CMD ["node", "app.js"]
