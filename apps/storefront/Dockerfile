# Etapa 1: Base
FROM node:22.23.4-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# Etapa 2: Dependencias
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/storefront/package.json ./apps/storefront/

RUN pnpm install --frozen-lockfile

# Etapa 3: Build
FROM base AS builder
WORKDIR /app

# Argumentos requeridos por Next.js en build-time
ARG NEXT_PUBLIC_MEDUSA_BACKEND_URL
ARG NEXT_PUBLIC_PUBLISHABLE_KEY
ARG NEXT_PUBLIC_DEFAULT_REGION

ENV NEXT_PUBLIC_MEDUSA_BACKEND_URL=$NEXT_PUBLIC_MEDUSA_BACKEND_URL
ENV NEXT_PUBLIC_PUBLISHABLE_KEY=$NEXT_PUBLIC_PUBLISHABLE_KEY
ENV NEXT_PUBLIC_DEFAULT_REGION=$NEXT_PUBLIC_DEFAULT_REGION

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN pnpm --filter storefront build

# Etapa 4: Runner
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=8000
EXPOSE 8000

COPY --from=builder /app/apps/storefront/public ./apps/storefront/public
COPY --from=builder /app/apps/storefront/.next/standalone ./
COPY --from=builder /app/apps/storefront/.next/static ./apps/storefront/.next/static

CMD ["node", "apps/storefront/server.js"]