import { Server as Engine } from '@socket.io/bun-engine'
import { Server } from 'socket.io'
import type { SocketListenEvents, SocketEmitEvents } from './src/types'

const PORT = Number(process.env.PORT || '3000')

const io = new Server<SocketListenEvents, SocketEmitEvents>()
const engine = new Engine({
  path: '/socket.io/',
})
io.bind(engine)

io.on('error', (error) => {
  console.error('Socket.IO error:', error)
})

io.on('connection', (socket) => {
  console.log('New client connected:', socket.id)

  socket.on('disconnect', (reason) => {
    console.log('Client disconnected:', socket.id, 'Reason:', reason)
  })

  setTimeout(() => {
    socket.emit('display', { text: { _0: '123' } })
  }, 1000)
})

Bun.serve({
  port: PORT,
  ...engine.handler(),
})

console.log('Server started on', PORT)
