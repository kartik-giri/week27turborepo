FROM oven/bun:1.3.12-alpine AS base
# Creating app folder in Image
WORKDIR /app

# Copying root truborepo package,bun.lock and turbo.json files
COPY ./package.json ./package.json
COPY ./bun.lock ./bun.lock
COPY ./turbo.json ./turbo.json

# Copying application package.json and needed packages package.json file
COPY ./apps/ws-server/package.json ./apps/ws-server/package.json
COPY ./packages/db/package.json ./packages/db/package.json 
COPY ./packages/typescript-config/package.json ./packages/typescript-config/package.json

# Run npm install to install packages in Image
RUN bun install

# Copying source code of application image and need packages source code.
COPY ./apps/ws-server ./apps/ws-server
COPY ./packages/db ./packages/db 
COPY ./packages/typescript-config/backend-config.json ./packages/typescript-config/backend-config.json

# Generate prisma client
# Each RUN is an isolated shell. When it finishes the shell dies. The next RUN always starts from your WORKDIR regardless.
# Turbo tries to read workspace context, cache, etc. For a single prisma generate command inside Docker just call prisma directly — simpler and more reliable:

RUN cd packages/db && bunx prisma generate

EXPOSE 3001

CMD [ "bun" ,"run", "start:ws" ]