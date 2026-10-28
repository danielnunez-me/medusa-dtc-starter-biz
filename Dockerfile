FROM node:22.23.4

WORKDIR /app

COPY . .

RUN corepack enable && corepack prepare pnpm@10.11.1 --activate
RUN pnpm install --no-frozen-lockfile
RUN pnpm --dir apps/backend run build

CMD ["pnpm", "--dir", "apps/backend", "run", "start"]
