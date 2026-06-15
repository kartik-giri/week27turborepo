FROM oven/bun:1.3.12-slim as base

WORKDIR /app

COPY ./package.json  ./package.json
COPY ./bun.lock ./bun.lock
COPY ./turbo.json ./turbo.json

COPY ./apps/web/package.json ./apps/web/package.json

RUN bun install

COPY ./apps/web ./apps/web
COPY ./packages/db ./packages/db

RUN cd packages/db && bunx prisma generate

RUN cd apps/web && bun run build

EXPOSE 3000

CMD ["bun" "run" "start:web"]