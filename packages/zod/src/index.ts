import {z} from "zod";

export const userSchema = z.object({
    username: z.string().min(2),
    password: z.string().min(3)
})