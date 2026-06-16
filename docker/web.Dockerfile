FROM oven/bun:1.3.12-slim as base

WORKDIR /app

ARG DATABASE_URL
COPY ./package.json  ./package.json
COPY ./bun.lock ./bun.lock
COPY ./turbo.json ./turbo.json

COPY ./apps/http-server/package.json ./apps/http-server/package.json
COPY ./apps/ws-server/package.json ./apps/ws-server/package.json
COPY ./apps/web/package.json ./apps/web/package.json

COPY ./packages/db/package.json ./packages/db/package.json 
COPY ./packages/typescript-config/package.json ./packages/typescript-config/package.json
COPY ./packages/eslint-config/package.json ./packages/eslint-config/package.json 
COPY ./packages/ui/package.json ./packages/ui/package.json 
COPY ./packages/zod/package.json ./packages/zod/package.json 

COPY ./packages/db ./packages/db

RUN bun install

COPY ./apps/web ./apps/web


RUN cd packages/db && bun prisma generate

RUN DATABASE_URL=${DATABASE_URL} bun run build

EXPOSE 3000

CMD ["bun" "run" "start:web"]