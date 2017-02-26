//
//  ASHook+BlockInsert.h
//  ASHookIt
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <ASHookIt/ASHookIt.h>

@interface ASHook (BlockInsert)

/**
 * Runs the given block on the target just before the given selector gets called.
 *
 * @param block The block that will run.
 * @param targetInstance The instance where you want to run the block.
 * @param originalSelector The original selector that will trigger the block and run after the block.
 *
 */
+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)targetInstance beforeInstanceSelector:(SEL)originalSelector;

/**
 * Runs the given block on the target just before the given selector gets called.
 *
 * @param block The block that will run.
 * @param targetClass The class where you want to run the block.
 * @param originalSelector The original selector that will trigger the block and run after the block.
 *
 */
+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)targetClass beforeClassSelector:(SEL)originalSelector;

@end
