# Etapa 1: Base
FROM node:22.23.4-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# Etapa 2: Instalar dependencias
FROM base AS deps
# libc6-compat es necesario a veces en Alpine para paquetes de Node.js
RUN apk add --no-cache libc6-compat
WORKDIR /app
# Copiamos archivos raíz del monorepo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
# Copiamos específicamente el package.json del storefront para la caché
COPY apps/storefront/package.json ./apps/storefront/
RUN pnpm install --frozen-lockfile

# Etapa 3: Construcción (Build)
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Construimos la aplicación de Next.js
RUN pnpm --dir apps/storefront run build

# Etapa 4: Imagen final de Producción
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copiamos solo lo necesario para correr en producción
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/apps/storefront/package.json ./apps/storefront/
COPY --from=builder /app/apps/storefront/.next ./apps/storefront/.next
COPY --from=builder /app/apps/storefront/public ./apps/storefront/public

# Exponemos el puerto (mantengo el 8000 que usaste en tu commit actual)
EXPOSE 8000
ENV PORT=8000

CMD ["pnpm", "--dir", "apps/storefront", "run", "start"]
