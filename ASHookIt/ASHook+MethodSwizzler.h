//
//  ASHook+MethodSwizzler.h
//  ASHookIt
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "ASHook.h"

@interface ASHook (MethodSwizzler)

/**
 * Replaces the implementations of the two given selectors of an instance.
 *
 * @param targetInstance The instance where you want to replace selectors.
 * @param originalSelector The original selector that is to be replaced.
 * @param newSelector The new selector will replace the original selector's implementation.
 *
 */
+ (void)swizzle:(id)targetInstance instanceSelector:(SEL)originalSelector withInstanceSelector:(SEL)newSelector;

/**
 * Replaces the implementations of the two given selectors of a class.
 *
 * @param targetClass The class where you want to replace selectors.
 * @param originalSelector The original selector that is to be replaced.
 * @param newSelector The new selector will replace the original selector's implementation.
 *
 */
+ (void)swizzle:(id)targetClass classSelector:(SEL)originalSelector withClassSelector:(SEL)newSelector;

@end
