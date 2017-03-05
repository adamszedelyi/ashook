//
//  ASHook+MethodSwizzler.m
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "ASHook+MethodSwizzler.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ASHook (MethodSwizzler)

#pragma mark - Public methods

+ (void)swizzle:(Class)swizzleTarget instanceSelector:(SEL)originalSelector withInstanceSelector:(SEL)newSelector {
    assert((swizzleTarget && swizzleTarget == [swizzleTarget class]) && "Plese use a class as the target.");
    Method originalMethod = class_getInstanceMethod(swizzleTarget, originalSelector);
    Method newMethod = class_getInstanceMethod(swizzleTarget, newSelector);
    [self swizzle:swizzleTarget selector:originalSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
}

+ (void)swizzle:(Class)swizzleTarget classSelector:(SEL)originalSelector withClassSelector:(SEL)newSelector {
    assert((swizzleTarget && swizzleTarget == [swizzleTarget class]) && "Plese use a class as the target.");
    id target = object_getClass(swizzleTarget);
    Method originalMethod = class_getClassMethod(target, originalSelector);
    Method newMethod = class_getClassMethod(target, newSelector);
    [self swizzle:target selector:originalSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
}

#pragma mark - Private methods

+ (void)swizzle:(Class)target
       selector:(SEL)originalSelector
    newSelector:(SEL)newSelector
 originalMethod:(Method)originalMethod
      newMethod:(Method)newMethod {
    BOOL methodAdded = class_addMethod(target, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (methodAdded) {
        class_replaceMethod(target, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end
