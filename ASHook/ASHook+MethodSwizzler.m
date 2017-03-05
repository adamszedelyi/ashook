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

+ (void)swizzle:(id)swizzleTarget instanceSelector:(SEL)originalSelector withInstanceSelector:(SEL)newSelector {
    id target = [swizzleTarget class];
    Method originalMethod = class_getInstanceMethod(target, originalSelector);
    Method newMethod = class_getInstanceMethod(target, newSelector);
    [self swizzle:target selector:originalSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
}

+ (void)swizzle:(id)swizzleTarget classSelector:(SEL)originalSelector withClassSelector:(SEL)newSelector {
    id target = object_getClass([swizzleTarget class]);
    Method originalMethod = class_getClassMethod(target, originalSelector);
    Method newMethod = class_getClassMethod(target, newSelector);
    [self swizzle:target selector:originalSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
}

#pragma mark - Private methods

+ (void)swizzle:(id)target
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
