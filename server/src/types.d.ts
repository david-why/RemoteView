// Socket.IO types

export interface SocketListenEvents {
  control: (target: string, content: DisplayContent) => void
  setname: (name: string) => void
}

export interface SocketEmitEvents {
  display: (content: DisplayContent) => void
}

// "Enums" (in quotes because Swift enums aren't actually enums...?)

interface DisplayContentBase {
  none?: never
  text?: never
  off?: never
  web?: never
}

interface DisplayContentNone extends DisplayContentBase {
  none: Record<string, never>
}

interface DisplayContentText extends DisplayContentBase {
  text: { _0: string }
}

interface DisplayContentOff extends DisplayContentBase {
  off: Record<string, never>
}

interface DisplayContentWeb extends DisplayContentBase {
  web: { _0: string }
}

export type DisplayContent = DisplayContentNone | DisplayContentText | DisplayContentOff | DisplayContentWeb
