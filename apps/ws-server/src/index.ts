import { WebSocketServer } from "ws";

const ws = new WebSocketServer({port:8080});

ws.on("connection",(socket)=>{
    socket.send("You are getting response back from ws listening on port 8080")
})