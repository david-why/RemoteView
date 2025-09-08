# RemoteView: Show any content on a remote device

This project lets you display a web page, some text, or turn off the display on a
remote iPhone / iPad device. For example, you can stick an iPad on a bulletin board,
turn on Guided Access, plug it in, and use it as an advertisement screen! The
devices don't have to be next to each other; they just need to be connected to the
Internet.

## Demo

Check out [the demo video](./server/public/demo.mp4)!

## How to Use

[Join the TestFlight here!](https://testflight.apple.com/join/T5NtpK3d)

## Technical Description

This project uses Socket.IO to communicate between the display device, the control
device, and the central server. The server is written in Bun and hosted on
[Hack Club's Nest](https://hackclub.app). The clients are written in Swift (duh).
