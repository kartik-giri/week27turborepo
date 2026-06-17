## How to deploy turborepo on VM with docker.
- docker system prune -a -f -> to clean docker disk space
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

6. The problem in app is that when we are build next project it SSG the page which is goos thing in some cases. But in our case ssg is not showing data added recnetly by user. and showing only the data which was fetched during build.
7. Solution for this is:
- export const dynamic = 'force-dynamic'  -> Forces the page to be server side render (SSR) — runs on every request, always fresh data.
- export const revalidate = 30 -> Page is static but regenerates every N seconds. Best balance of performance and freshness
8. With no SSG means in dockerfile image doesn't have the need to communicate with db container in build phase.

9. But what if next/any app dockerfile needs to intract with db container in image build phase? And next app need db url cause it is sedning request to get data and render it in build phase.

In CD for building and pushing image we need real DB url cause next app images needs real db so it can fetch real data cause we are building next app in dockerfile

DATABASE_URL must be real
Database must be reachable

because the build actually needs data.

1. Than we need to give db instance url in build phase of image.
2. Best approch is to pass build arg while while building the image.
3. Like this ARG DATABASE_URL
    - RUN DATABASE_URL=${DATABASE_URL} bun run build
    - docker build --build-arg DATABASE_URL=postgresurl -t kartikgiri/imagename .
10. After creating docker file and CD pipeline now we need VM to deploy updated repo on VM automatically.
1. We need to create scret for vm private key so github vm can ssh into our VM can pull latest branch and run it.
2. NOw i need to install docker cause our apps image contains every thing they need to run.
3. https://docs.docker.com/engine/install/ubuntu/ -> follow this article to install dcoker on VM ubuntu os.
4. sudo usermod -aG docker ubuntu && newgrp docker -> to allow use docker withour sudo on vm

11. Once you move to containers, Docker becomes the thing that keeps your processes alive, while GitHub Actions only deploys new versions. PM2 is most useful when you're running Node.js directly on the VM without containers.