FROM node:22.23.4-bookworm-slim

ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

COPY . .

# 1. Instalar dependencias
ENV NODE_ENV=development
RUN pnpm install --no-frozen-lockfile

# 2. Compilar el proyecto (esto crea la carpeta .medusa/server)
WORKDIR /app/apps/backend
RUN pnpm exec medusa build

# === EL CAMBIO CRÍTICO ===
# 3. Moverse al directorio del servidor standalone generado por Medusa v2
WORKDIR /app/apps/backend/.medusa/server

# 4. Configurar producción y puerto
ENV NODE_ENV=production
EXPOSE 9000

# 5. Arrancar utilizando el script del nuevo directorio
CMD ["npm", "run", "start"]
