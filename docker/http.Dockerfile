FROM oven/bun:1.3.12-slim AS base
WORKDIR /app

# Install OpenSSL required by Prisma's engines
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Copy root configurations
COPY ./package.json ./package.json
COPY ./bun.lock ./bun.lock
COPY ./turbo.json ./turbo.json

# Copy all package.json files for workspace mapping
COPY ./apps/http-server/package.json ./apps/http-server/package.json
COPY ./apps/ws-server/package.json ./apps/ws-server/package.json
COPY ./apps/web/package.json ./apps/web/package.json

COPY ./packages/db/package.json ./packages/db/package.json 
COPY ./packages/typescript-config/package.json ./packages/typescript-config/package.json
COPY ./packages/eslint-config/package.json ./packages/eslint-config/package.json 
COPY ./packages/ui/package.json ./packages/ui/package.json 
COPY ./packages/zod/package.json ./packages/zod/package.json 

# Copy the entire DB folder containing schema.prisma BEFORE install
COPY ./packages/db ./packages/db

# Prevent Prisma installation hooks from triggering prematurely during bun install
ENV PRISMA_SKIP_POSTINSTALL_GENERATE=true

# Install your monorepo dependencies
RUN bun install

# Copy source code files needed for compilation
COPY ./apps/http-server ./apps/http-server
COPY ./packages/typescript-config/backend-config.json ./packages/typescript-config/backend-config.json

# ---- FIX: Use bunx with the --bun flag to bypass Node.js requirement ----
RUN bunx --bun prisma generate --schema=./packages/db/schema.prisma

EXPOSE 3001

CMD [ "bun" ,"run", "start:http" ]







# FROM oven/bun:1.3.12-slim AS base
# # Creating app folder in Image
# WORKDIR /app
# RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*
# # RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# # Copying root truborepo package,bun.lock and turbo.json files
# COPY ./package.json ./package.json
# COPY ./bun.lock ./bun.lock
# COPY ./turbo.json ./turbo.json

# # Copying application package.json and needed packages package.json file
# COPY ./apps/http-server/package.json ./apps/http-server/package.json
# COPY ./apps/ws-server/package.json ./apps/ws-server/package.json
# COPY ./apps/web/package.json ./apps/web/package.json

# COPY ./packages/db/package.json ./packages/db/package.json 
# COPY ./packages/typescript-config/package.json ./packages/typescript-config/package.json
# COPY ./packages/eslint-config/package.json ./packages/eslint-config/package.json 
# COPY ./packages/ui/package.json ./packages/ui/package.json 
# COPY ./packages/zod/package.json ./packages/zod/package.json 

# COPY ./packages/db ./packages/db

# # Run npm install to install packages in Image
# RUN bun install

# # Copying source code of application image and need packages source code.
# COPY ./apps/http-server ./apps/http-server
# # COPY ./packages/db ./packages/db 
# COPY ./packages/typescript-config/backend-config.json ./packages/typescript-config/backend-config.json

# # Generate prisma client
# # Each RUN is an isolated shell. When it finishes the shell dies. The next RUN always starts from your WORKDIR regardless.
# # Turbo tries to read workspace context, cache, etc. For a single prisma generate command inside Docker just call prisma directly — simpler and more reliable:

# RUN bunx prisma generate --schema=./packages/db/schema.prisma

# EXPOSE 3001

# CMD [ "bun" ,"run", "start:http" ]