## How to deploy turborepo on VM with docker.
1. Create mutiple applications.
2. create rpisma package
3. Start postgres container cause prisma needs postgres instance url.

4. It is better to regenrate the client after migrating new scheema.
5. docker build
      ↓
RUN npx prisma generate    ← generates client from schema
RUN npm run build          ← compiles TypeScript
(no migrate here — no DB available at build time)
      ↓
docker run
      ↓
CMD: npx prisma migrate deploy && npm start
          ↓                      ↓
   creates/updates tables    starts express
   in postgres               with fresh client
The client gets generated at build time from your schema file — it doesn't need a live database for that. The migration runs at runtime when postgres is actually reachable.