//
//  ASHook+BlockInsert.h
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <ASHook/ASHook.h>

@interface ASHook (BlockInsert)

/**
 * Runs the given block on the target just before the given selector gets called.
 *
 * @param block The block that will run.
 * @param hookTarget The instance or class where the selector can be found.
 * @param hookSelector The original selector that will trigger the block.
 *
 */
+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)hookTarget beforeInstanceSelector:(SEL)hookSelector;

/**
 * Runs the given block on the target just before the given selector gets called.
 *
 * @param block The block that will run.
 * @param hookTarget The instance or class where the selector can be found.
 * @param hookSelector The original selector that will trigger the block.
 *
 */
+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)hookTarget beforeClassSelector:(SEL)hookSelector;

@end
