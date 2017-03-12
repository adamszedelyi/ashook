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
#import "ExampleViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

+ (void)initialize {
    // Example 1: simple instance method swizzling
    [ASHook swizzle:self instanceSelector:@selector(logHelloWorld) withInstanceSelector:@selector(logGoodbyeWorld)];
    
    // Example 2: simple class method swizzling
    [ASHook swizzle:self classSelector:@selector(one) withClassSelector:@selector(two)];
    
    // Example 3: an instance method hook (before it runs) - the scope can be even all UIViewController objects
    [ASHook hookTarget:[AppDelegate class] instanceSelector:@selector(applicationDidFinishLaunching:) block:^(__unsafe_unretained id _self) {
        NSLog(@"applicationDidFinishLaunching has been called on %@!", NSStringFromClass([_self class]));
    }];
    
    // Example 4: a class method hook (before it runs)
    [ASHook hookTarget:[EvilSingleton class] classSelector:@selector(alloc) block:^(__unsafe_unretained id _self) {
        NSLog(@"%@ is allocated.", NSStringFromClass([_self class]));
    }];
    
    // Example 5: Observing allocations
    [ASHook startObservingAllocationsOnClass:[EvilSingleton class] maxAllocations:1 failureHandler:^(__unsafe_unretained id _self) {
        NSLog(@"Yikes! The singleton has been allocated more than once!");
    }];
    
    [EvilSingleton sharedInstance]; // Designated singleton accessor
    (void)[[EvilSingleton alloc] init]; // Allocating the singleton by mistake
    
    // Example 6: Observing count of living instances of a class
    [ASHook startObservingInstanceCountOnClass:[ExampleViewController class] maxInstanceCount:5 failureHandler:^(__unsafe_unretained id _self) {
        NSLog(@"Yikes! %@ has more than 5 instances!", _self);
    }];
    
    NSMutableSet *viewControllers = [NSMutableSet setWithObjects:[ExampleViewController new], [ExampleViewController new], [ExampleViewController new], [ExampleViewController new], [ExampleViewController new], nil]; // Good so far: 5 instances are living
    [viewControllers removeObject:[viewControllers anyObject]]; // Down to 4 instances: still good
    [viewControllers addObjectsFromArray:@[[ExampleViewController new], [ExampleViewController new]]]; // There are now more than 5 living instances
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

+ (NSUInteger)one {
    return 2;
}

+ (NSUInteger)two {
    return 1;
}

@end
