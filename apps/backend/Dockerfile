FROM node:22.23.4-bookworm-slim

# 1. Configurar pnpm
ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# 2. Copiar todo el monorepo para mantener la estructura del workspace
COPY . .

# 3. Forzar modo desarrollo para instalar todas las dependencias (incluyendo Vite y admin-bundler)
ENV NODE_ENV=development
RUN pnpm install --no-frozen-lockfile

# 4. ENTRAR físicamente a la carpeta del backend (El paso que resuelve el error de las rutas)
WORKDIR /app/apps/backend

# 5. Compilar directamente dentro del contexto del backend
RUN pnpm exec medusa build

# 6. Configurar entorno para ejecución en producción
ENV NODE_ENV=production
EXPOSE 9000

# 7. Iniciar el servidor (como ya estamos en /app/apps/backend, no necesitamos --dir)
CMD ["pnpm", "run", "start"]
