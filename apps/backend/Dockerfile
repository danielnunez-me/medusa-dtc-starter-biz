FROM node:22.23.4-bookworm-slim AS base
ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

FROM base AS deps
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/package.json
COPY apps/storefront/package.json ./apps/storefront/package.json
RUN pnpm install --no-frozen-lockfile

FROM deps AS builder
COPY . .
RUN pnpm --dir apps/backend run build

# valida que el admin sí se haya generado
RUN test -f /app/apps/backend/.medusa/admin/index.html || { echo "ERROR: admin build not generated"; find /app/apps/backend/.medusa -maxdepth 3 -type f | head; exit 1; }

FROM node:22.23.4-bookworm-slim AS runner
ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app

COPY --from=builder /app /app
EXPOSE 9000

CMD ["sh", "-lc", "cd /app/apps/backend && NODE_ENV=production pnpm run start"]
