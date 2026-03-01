### Stage 1: Build Stage #####

FROM node:latest AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY app.js ./

### Stage 2: Runtime stage

FROM node:20-alpine 

RUN apk add --no-cach tini

RUN appgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app /app

RUN chown -R appuser:appgroup /app

USER appuser

ENV NODE_ENV=production

ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["node", "app.js"]



