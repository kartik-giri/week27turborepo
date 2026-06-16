import { prisma } from "@repo/db"


const Home =async ()=>{
  const allUser = await prisma.user.findMany();
  return (
    <div>
      {
        JSON.stringify(allUser)
      }
    </div>
  )
}

export default Home
export const dynamic = 'force-dynamic'