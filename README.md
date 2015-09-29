#Blink

Blink is an iOS app that lets you write BrainFuck code by blinking your eyes. It's built on top of the CIFaceDetector functionality in the AVFoundation Framework. By checking for eye states and matching them to characters, it enables you to type a character for every sequence of two blinks. They are as follows:

Both -> Both: Backspace
Both -> Left: <
Both -> Right: >
Left -> Both -> Both: Run code on server
Left -> Left: [
Left -> Right: ]
Right -> Both: .
Right -> Left: -
Right -> Right: +

There is an interpreter written in js that runs on a Parse server. I'm removing my Parse keys, but feel free to create your own Parse App and then initialize the Cloud Code with my Cloud Code directory.

Otherwise, there is a functioning local interpreter written in C++ attached. Check the commented out code in BLViewController.

Happy Blinking!
