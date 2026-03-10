FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

FROM node:20-alpine

WORKDIR /app

RUN addgroup -S appgroup && adduser -S credpaluser -G appgroup

COPY --from=builder /app .

USER credpaluser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]