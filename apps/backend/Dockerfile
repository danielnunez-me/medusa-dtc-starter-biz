FROM node:22.23.4-bookworm-slim

ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

COPY . .

# 1. Forzar entorno de desarrollo para asegurar que se instalen devDependencies
ENV NODE_ENV=development
RUN pnpm install --no-frozen-lockfile

# 2. Compilar (ahora sí encontrará las herramientas del admin)
RUN pnpm --dir apps/backend run build

# 3. Cambiar a producción para el entorno de ejecución
ENV NODE_ENV=production
EXPOSE 9000

CMD ["pnpm", "--dir", "apps/backend", "run", "start"]
