//
//  FirstViewController.m
//  ASHookItDemo
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "FirstViewController.h"
#import <ASHookIt/ASHookIt.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

#pragma mark - Swizzling example 1

+ (void)initialize {
    // A simple class method swizzling example.
    [ASHook swizzle:self classSelector:@selector(alloc) withClassSelector:@selector(swizzledAlloc)];
}

+ (instancetype)swizzledAlloc {
    NSLog(@"Whoah! Swizzled allocation of this class is cool!");
    return [super alloc];
}

#pragma mark - Swizzling example 2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // A simple instance method swizzling example.
    [ASHook swizzle:self instanceSelector:@selector(logHelloWorld) withInstanceSelector:@selector(logGoodbyeWorld)];
    
    [self logHelloWorld];
}

- (void)logGoodbyeWorld {
    NSLog(@"Hello World!");
}

- (void)logHelloWorld {
    NSLog(@"Goodbye World!");
}

@end
