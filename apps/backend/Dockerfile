FROM node:22.23.4-bookworm-slim

# Configurar pnpm
ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# Copiar todo el monorepo para resolver el workspace correctamente
COPY . .

# Instalar dependencias (ignorando errores de sincronización del lockfile)
RUN pnpm install --no-frozen-lockfile

# Construir el backend y el panel de administración
RUN pnpm --dir apps/backend run build

# Exponer el puerto
EXPOSE 9000

# Iniciar el servidor
CMD ["pnpm", "--dir", "apps/backend", "run", "start"]
