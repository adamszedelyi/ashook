//
//  EvilSingleton.h
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 03. 05..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvilSingleton : NSObject

+ (instancetype)sharedInstance;

- (void)shouldSingletonsBeUsedInAproject;
- (void)printNever;

@end
