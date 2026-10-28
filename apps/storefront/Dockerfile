# Etapa 1: Base
FROM node:22.23.4-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# Etapa 2: Instalar dependencias del monorepo
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copiamos la estructura completa del workspace para resolver dependencias internas
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/storefront/package.json ./apps/storefront/
# Si tienes paquetes compartidos (ej. packages/*), cópialos también aquí si es necesario

# Instalamos todas las dependencias del monorepo manteniendo los enlaces simbólicos
RUN pnpm install --frozen-lockfile

# Etapa 3: Construcción (Build)
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /pnpm /pnpm
COPY . .

# Usamos el filtro de pnpm para compilar el storefront y sus dependencias internas correctamente
RUN pnpm --filter storefront build

# Etapa 4: Imagen final de Producción
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copiamos lo necesario para correr la app de Next.js en producción
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/apps/storefront/package.json ./apps/storefront/
COPY --from=builder /app/apps/storefront/.next ./apps/storefront/.next
COPY --from=builder /app/apps/storefront/public ./apps/storefront/public

EXPOSE 8000
ENV PORT=8000

CMD ["pnpm", "--dir", "apps/storefront", "run", "start"]
