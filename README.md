# ashook
Swizzling, hooking, observing in Objective-C

What is this?
- A dynamic lib for iOS and macOS. There are three layers built on top of each other: method swizzling, hooking and observing lifecycle events of NSObjects. All of these layers are exposed to you so feel free to use them.

Do I need this?
- I wouldn't build an application on Objective-C runtime magic (such as swizzling) but this lib already saved one of my apps from unwanted behaviors more than once. I tend to look at it as some sort of a debugging tool or a tool that helps programmers to not make certain mistakes. (eg. allocating a singleton more than once, having too many instances of a specific class, etc.)

How do I use this?
- I included numerous examples in the demo application, please visit: https://github.com/sedios/ashook/blob/master/ASHookDemo/ASHookDemo/AppDelegate.m
