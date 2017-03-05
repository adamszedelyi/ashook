//
//  EvilSingleton.h
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 03. 05..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EvilSingleton : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)swizzledAlloc;

- (void)shouldSingletonsBeUsedInAproject;
- (void)printNever;

@end
