// Socket.IO types

export interface SocketListenEvents {
  control: (target: string, content: DisplayContent) => void
  setname: (name: string) => void
}

export interface SocketEmitEvents {
  display: (content: DisplayContent) => void
}

// "Enums" (in quotes because Swift enums aren't actually enums...?)

interface DisplayContentNone {
  none: Record<string, never>
  text?: never
}

interface DisplayContentText {
  none?: never
  text: { _0: string }
}

export type DisplayContent = DisplayContentNone | DisplayContentText
