import { prisma } from "@repo/db";
import { server } from "typescript"

Bun.serve({
    port: 8080,
    fetch(req,server){
        // Every incoming request hits here first
        // fetch() is like your express app.use() — handles all HTTP
        //upgrade http request to ws request
        if(server.upgrade(req)){
            // Client sent a WS handshake request
            // upgrade() converts HTTP → WebSocket connection
            // returns true if upgrade succeeded
            return
        }
        // If upgrade failed (normal HTTP request, not a WS request)
        //if normal http request and no ws handshake request than send back back http response
        return new Response("Upgrade failed", {status:500});
    },
    websocket:{
        async message(ws,message){
            await prisma.user.create({
                data:{
                    username: Math.random().toString(),
                    password: Math.random().toString()
                }
            })
            ws.send(message)
        }
    }
})

//We are just using js short hand syntax for function key value pair.
// fetch(req.server) just means fetch: (req,server)=>{}

//Bun calls those functions internally and passes the arguments automatically — we just define what the parameters are named.








// import { WebSocketServer } from "ws";

// const ws = new WebSocketServer({port:8080});

// ws.on("connection",(socket)=>{
//     socket.send("You are getting response back from ws listening on port 8080")
// })