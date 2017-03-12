//
//  EvilSingleton.m
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 03. 05..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "EvilSingleton.h"

@implementation EvilSingleton

+ (instancetype)sharedInstance {
    static EvilSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EvilSingleton alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)swizzledAlloc {
    NSLog(@"Whoah! Swizzled allocation of %@ is cool!", NSStringFromClass([self class]));
    return [super alloc];
}

- (void)shouldSingletonsBeUsedInAproject {
    NSLog(@"Yes");
}

- (void)printNever {
    NSLog(@"Never");
}

@end
