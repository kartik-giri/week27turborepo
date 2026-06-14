import express from "express";
import { prisma } from "@repo/db";

const app = express();

app.use(express.json());

app.get("/users", (req, res) => {
    prisma.user.findMany()
        .then(users => {   //Handling promise using .then and .catch syntax
            res.json(users);
        })
        .catch(err => {
            res.status(500).json({ error: err.message });
        });
})

app.post("/user", (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        res.status(400).json({ error: "Username and password are required" });
        return
    }

    prisma.user.create({
        data: {
            username,
            password
        }
    })
        .then(user => {
            res.status(201).json(user);
        })
        .catch(err => {
            res.status(500).json({ error: err.message });
        });
})

app.listen(3001);







































// import { prisma } from "@repo/db";
// import { userSchema } from "@repo/zod";
// import express from "express";

// const app = express();

// app.post("/signup", async (req, res) => {
//     const user = userSchema.safeParse(req.body);
//     if (!user.success) {
//         res.status(400).json({
//             message: "User signup credentials are wrong"
//         })
//         return
//     }
//     const { username, password } = user.data
//     try {
//         await prisma.user.create({
//             data: {
//                 username: username,
//                 password: password
//             }
//         })
//         res.status(200).json({
//             message: `${username} Thanks for signing up!`
//         })
//     } catch (e) {
//         res.status(400).json({
//             message: `Error occured while singing up:${e}`
//         })
//     }
// })

// app.get("/", async (req, res) => {
//     res.status(200).json({
//         message: `Getting response back from http server listening on port 3001`
//     })
// })

// app.listen(3001, () => {
//     console.log(`Http server is listening on port 3001`)
// })