//
//  ASHook+MethodSwizzler.h
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "ASHook.h"

@interface ASHook (MethodSwizzler)

/**
 * Replaces the implementations of the two given instance selectors in a class object.
 *
 * @param swizzleTarget The target (instance or class) where you want to replace selectors.
 * @param originalSelector The original selector that is to be replaced.
 * @param newSelector The new selector will replace the original selector's implementation.
 *
 */
+ (void)swizzle:(id)swizzleTarget instanceSelector:(SEL)originalSelector withInstanceSelector:(SEL)newSelector;

/**
 * Replaces the implementations of the two given class selectors in a class object.
 *
 * @param swizzleTarget The target (instance or class) where you want to replace selectors.
 * @param originalSelector The original selector that is to be replaced.
 * @param newSelector The new selector will replace the original selector's implementation.
 *
 */
+ (void)swizzle:(id)swizzleTarget classSelector:(SEL)originalSelector withClassSelector:(SEL)newSelector;

@end
