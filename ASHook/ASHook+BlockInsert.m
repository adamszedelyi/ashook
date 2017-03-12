//
//  ASHook+BlockInsert.m
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "ASHook+BlockInsert.h"
#import "ASHook+MethodSwizzler.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ASHook ()

+ (void)swizzle:(Class)swizzleTarget
       selector:(SEL)originalSelector
    newSelector:(SEL)newSelector
 originalMethod:(Method)originalMethod
      newMethod:(Method)newMethod;

@end

@implementation ASHook (BlockInsert)

#pragma mark - Public methods

+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(Class)hookTarget beforeInstanceSelector:(SEL)hookSelector {
    assert((hookTarget && hookTarget == [hookTarget class]) && "Plese use a class as the target.");
    Method originalMethod = class_getInstanceMethod(hookTarget, hookSelector);
    SEL newSelector = [self insertBlock:block onTarget:hookTarget originalSelector:hookSelector originalMethod:originalMethod];
    if (newSelector) {
        Method newMethod = class_getInstanceMethod(hookTarget, newSelector);
        [ASHook swizzle:hookTarget selector:hookSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
    }
}

+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(Class)hookTarget beforeClassSelector:(SEL)hookSelector {
    assert((hookTarget && hookTarget == [hookTarget class]) && "Plese use a class as the target.");
    id target = object_getClass(hookTarget);
    Method originalMethod = class_getClassMethod(target, hookSelector);
    SEL newSelector = [self insertBlock:block onTarget:target originalSelector:hookSelector originalMethod:originalMethod];
    if (newSelector) {
        Method newMethod = class_getClassMethod(target, newSelector);
        [ASHook swizzle:target selector:hookSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
    }
}

#pragma mark - Private methods

/*! @brief Creating and adding a new implementation for the original method with the block included. */
+ (SEL)insertBlock:(void (^)(__unsafe_unretained id _self))block
          onTarget:(Class)target
originalSelector:(SEL)originalSelector
  originalMethod:(Method)originalMethod {
    NSString *swizzledMethodSuffix = @"_ASMethodSwizzled";
    NSString *swizzledMethodName = [NSString stringWithFormat:@"%@%@", NSStringFromSelector(originalSelector), swizzledMethodSuffix];
    SEL newSelector = [self selectorToSwizzleWithName:swizzledMethodName onTarget:target];
    id actionBlock = ^(__unsafe_unretained id _self) {
        if (block != nil) {
            block(_self);
        }
        ((void ( *)(id, SEL))objc_msgSend)(_self, newSelector); // Using ObjC messaging directly to avoid ARC messing with the lifecycle of the original object. (ie. had issues with some classes' dealloc otherwise)
    };
    IMP impl = imp_implementationWithBlock(actionBlock);
    const char *encoding = method_getTypeEncoding(originalMethod);
    if (!class_addMethod(target, newSelector, impl, encoding)) {
        NSLog(@"Failed to add method: %@ on %@", NSStringFromSelector(newSelector), target);
        return nil;
    }
    return newSelector;
}

/*! @brief Creating a unique named selector for the original method - handling the case where multiple hook requests are received on the same method. */
+ (SEL)selectorToSwizzleWithName:(NSString *)swizzledMethodName onTarget:(Class)target {
    SEL newSelector = NSSelectorFromString(swizzledMethodName);
    NSUInteger retries = 0;
    while (class_respondsToSelector(target, newSelector) && retries < 100) { // There's already a selector with the swizzled name - create a new one
        NSString *suffixedSwizzledMethodName = [NSString stringWithFormat:@"%@%u", swizzledMethodName, arc4random_uniform(INT_MAX)];
        newSelector = NSSelectorFromString(suffixedSwizzledMethodName);
        retries++;
    }
    return newSelector;
}

@end
