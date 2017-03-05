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

+ (void)swizzle:(id)swizzleTarget
       selector:(SEL)originalSelector
    newSelector:(SEL)newSelector
 originalMethod:(Method)originalMethod
      newMethod:(Method)newMethod;

@end

@implementation ASHook (BlockInsert)

#pragma mark - Public methods

+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)hookTarget beforeInstanceSelector:(SEL)hookSelector {
    id target = [hookTarget class];
    Method originalMethod = class_getInstanceMethod(target, hookSelector);
    SEL newSelector = [self insertBlock:block onTarget:target originalSelector:hookSelector originalMethod:originalMethod];
    if (newSelector) {
        Method newMethod = class_getInstanceMethod(target, newSelector);
        [ASHook swizzle:target selector:hookSelector newSelector:newSelector originalMethod:originalMethod newMethod:newMethod];
    }
}

+ (void)runBlock:(void (^)(__unsafe_unretained id _self))block onTarget:(id)hookTarget beforeClassSelector:(SEL)hookSelector {
    id target = object_getClass([hookTarget class]);
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
          onTarget:(id)target
originalSelector:(SEL)originalSelector
  originalMethod:(Method)originalMethod {
    NSString *swizzledMethodSuffix = @"_ASMethodSwizzled";
    NSString *swizzledMethodName = [NSString stringWithFormat:@"%@%@", NSStringFromSelector(originalSelector), swizzledMethodSuffix];
    SEL newSelector = NSSelectorFromString(swizzledMethodName);
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

@end
