FROM node:22.23.4-bookworm-slim

ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
ENV NODE_ENV=production
ENV PORT=9000

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm --dir apps/backend run build

EXPOSE 9000

CMD ["pnpm", "--dir", "apps/backend", "run", "start"]
