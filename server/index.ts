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

  socket.on('control', (target, content) => {
    console.log('Control command from', socket.id, 'to', target, 'Content:', content)
    io.to(target).emit('display', content)
  })

  socket.on('setname', (name) => {
    console.log('Client set name:', socket.id, 'New name:', name)
    socket.rooms.forEach((r) => {
      if (r != socket.id) socket.leave(r)
    })
    socket.join(name)
  })

  setTimeout(() => {
    socket.emit('display', { off: {} })
  }, 1000)
})

Bun.serve({
  port: PORT,
  ...engine.handler(),
})

console.log('Server started on', PORT)
