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

6. Let's use bun native websocket.

7.  I have created 3 application ws,http and next with prisma package and postgres as running docker container.
8. How to containerize these 3 applications?
-  Writing dockerfile.
-  Writing docker-compose file.
-  Writng CI/CD pipleline to deploy it on dockerhub.
-  Writng CI/CD pipleline to pull it to VM.

1. Create docker folder
2. Create indvidual dockerfile for each app like app.Dockerfile
3. The issue with turborepo is that are mutiple package files so for that we need to copy files/folders individually.
4. Hot reloading is when your app automatically restarts or updates when you change your code — without you manually stopping and restarting the server.

5. Static site generation means the page which content doesn't change and stay same for every users is generated statically at build time.
- SSG = pages are built into plain HTML files once at build time, stored on a CDN, and served instantly to every user without hitting your server or database at runtime.

6. The problem in app is that when we are build next project it SSG the page which is goof thing in some cases. But in our case ssg is not showing data added recnetly by user. and showing only the data which was fetched during build.
7. Solution for this is:
- export const dynamic = 'force-dynamic'  -> Forces the page to be server side render (SSR) — runs on every request, always fresh data.
- export const revalidate = 30 -> Page is static but regenerates every N seconds. Best balance of performance and freshness
8. With no SSG means in dockerfile image doesn't have the need to communicate with db container in build phase.

9. But what if next/any app dockerfile needs to intract with db container in image build phase?
1. Than we need to give db instance url in build phase of image.
2. Best approch is to pass build arg while while building the image.
3. Like this ARG DATABASE_URL
    - RUN DATABASE_URL=${DATABASE_URL} bun run build
    - docker build --build-arg DATABASE_URL=postgresurl -t kartikgiri/imagename .