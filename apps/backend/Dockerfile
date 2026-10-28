FROM node:22.23.4-bookworm-slim

ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

COPY package.json ./
COPY pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/package.json
COPY apps/storefront/package.json ./apps/storefront/package.json

COPY . .

RUN pnpm install --no-frozen-lockfile
RUN cd /app/apps/backend && NODE_ENV=development pnpm run build

EXPOSE 9000

CMD ["sh", "-lc", "cd /app/apps/backend && NODE_ENV=production pnpm run start"]
