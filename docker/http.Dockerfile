FROM oven/bun:1.3.12-debian AS base
# Creating app folder in Image
WORKDIR /app

# Copying root truborepo package,bun.lock and turbo.json files
COPY ./package.json ./package.json
COPY ./bun.lock ./bun.lock
COPY ./turbo.json ./turbo.json

# Copying application package.json and needed packages package.json file
COPY ./apps/http-server/package.json ./apps/http-server/package.json
COPY ./apps/ws-server/package.json ./apps/ws-server/package.json
COPY ./apps/web/package.json ./apps/web/package.json

COPY ./packages/db/package.json ./packages/db/package.json 
COPY ./packages/typescript-config/package.json ./packages/typescript-config/package.json
COPY ./packages/eslint-config/package.json ./packages/eslint-config/package.json 
COPY ./packages/ui/package.json ./packages/ui/package.json 
COPY ./packages/zod/package.json ./packages/zod/package.json 

COPY ./packages/db ./packages/db

# Run npm install to install packages in Image
RUN bun install

# Copying source code of application image and need packages source code.
COPY ./apps/http-server ./apps/http-server
# COPY ./packages/db ./packages/db 
COPY ./packages/typescript-config/backend-config.json ./packages/typescript-config/backend-config.json

# Generate prisma client
# Each RUN is an isolated shell. When it finishes the shell dies. The next RUN always starts from your WORKDIR regardless.
# Turbo tries to read workspace context, cache, etc. For a single prisma generate command inside Docker just call prisma directly — simpler and more reliable:

RUN cd packages/db && bunx --bun turbo run db:generate

EXPOSE 3001

CMD [ "bun" ,"run", "start:http" ]