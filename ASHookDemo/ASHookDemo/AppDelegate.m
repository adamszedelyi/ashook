//
//  AppDelegate.m
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 03. 05..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "AppDelegate.h"
#import <ASHook/ASHook.h>
#import "EvilSingleton.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

+ (void)initialize {
    // Example 1: simple instance method swizzling
    [ASHook swizzle:self instanceSelector:@selector(logHelloWorld) withInstanceSelector:@selector(logGoodbyeWorld)];
    
    // Example 2: class method swizzling
    [ASHook swizzle:[EvilSingleton class] classSelector:@selector(alloc) withClassSelector:@selector(swizzledAlloc)];
    
    // Example 3: an instance method hook (before it runs) - the scope can be even all UIViewController objects
    [ASHook hookTarget:[AppDelegate class] instanceSelector:@selector(applicationDidFinishLaunching:) block:^(__unsafe_unretained id _self) {
        NSLog(@"applicationDidFinishLaunching has been called on %@!", NSStringFromClass([_self class]));
    }];
    
    // Example 4: a class method hook (before it runs)
    [ASHook hookTarget:[EvilSingleton class] classSelector:@selector(alloc) block:^(__unsafe_unretained id _self) {
        NSLog(@"alloc will run on %@ - will there be any funny messages in it?", NSStringFromClass([_self class]));
    }];
    
    // Example 5: Lifecycle
    [ASHook swizzle:[[EvilSingleton sharedInstance] class] instanceSelector:@selector(shouldSingletonsBeUsedInAproject) withInstanceSelector:@selector(printNever)];
    NSLog(@"Should I use singletons?");
    [[EvilSingleton sharedInstance] shouldSingletonsBeUsedInAproject];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self logHelloWorld];
}

- (void)logGoodbyeWorld {
    NSLog(@"Hello World!");
}

- (void)logHelloWorld {
    NSLog(@"Goodbye World!");
}

@end
