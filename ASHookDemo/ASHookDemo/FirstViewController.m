//
//  FirstViewController.m
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "FirstViewController.h"
#import <ASHook/ASHook.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

#pragma mark - Swizzling example 1

+ (void)initialize {
    // Example 1: simple instance method swizzling
    [ASHook swizzle:self instanceSelector:@selector(logHelloWorld) withInstanceSelector:@selector(logGoodbyeWorld)];
    
    // Example 2: class method swizzling
    [ASHook swizzle:self classSelector:@selector(alloc) withClassSelector:@selector(swizzledAlloc)];
    
    // Example 3: an instance method hook (before it runs) - the scope can be even all UIViewController objects
    [ASHook runBlock:^(__unsafe_unretained id _self) {
        NSLog(@"viewDidLoad will be called on %@!", _self);
    } onTarget:[UIViewController class] beforeInstanceSelector:@selector(viewDidLoad)];
    
    // Example 4: a class method hook (before it runs)
    [ASHook runBlock:^(__unsafe_unretained id _self) {
        NSLog(@"alloc will run - will there be any funny messages in it?");
    } onTarget:self beforeClassSelector:@selector(alloc)];
}

+ (instancetype)swizzledAlloc {
    NSLog(@"Whoah! Swizzled allocation of this class is cool!");
    return [super alloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logHelloWorld];
}

- (void)logGoodbyeWorld {
    NSLog(@"Hello World!");
}

- (void)logHelloWorld {
    NSLog(@"Goodbye World!");
}

@end
