import { prisma } from "@repo/db";
import express from "express";

const app = express();

app.post("/", async(req,res)=>{
    await prisma.user.create({
        data:{
            username: Math.random().toString(),
            password: Math.random().toString(),
        }
    })
    res.status(200).json({
        message:`You are getting response back from http server listening on port 3001 `
    })
})

app.get("/",async(req,res)=>{
    res.status(200).json({
        message:`Getting response back from http server listening on port 3001`
    })
} )

app.listen(3001, ()=>{
    console.log(`Http server is listening on port 3001`)
})