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
 * @param hookTarget The class object where the selector can be found.
 * @param hookSelector The original selector that will trigger the block.
 * @param block The block that will run.
 *
 */
+ (void)hookTarget:(Class)hookTarget instanceSelector:(SEL)hookSelector block:(void (^)(__unsafe_unretained id _self))block;

/**
 * Runs the given block on the target just before the given selector gets called.
 *
 * @param hookTarget The class object where the selector can be found.
 * @param hookSelector The original selector that will trigger the block.
 * @param block The block that will run.
 *
 */
+ (void)hookTarget:(Class)hookTarget classSelector:(SEL)hookSelector block:(void (^)(__unsafe_unretained id _self))block;

@end
