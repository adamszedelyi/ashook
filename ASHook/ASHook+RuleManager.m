//
//  ASHook+RuleManager.m
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 03. 12..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "ASHook+RuleManager.h"
#import "SanityRules.h"

@implementation ASHook (RuleManager)

+ (void)startObservingAllocationsOnClass:(Class)target maxAllocations:(NSUInteger)maxAllocations failureHandler:(void (^)(__unsafe_unretained id _self))failureHandler {
    assert((target && target == [target class]) && "Plese use a class as the target.");
    NSString *targetClassName = NSStringFromClass(target);
    NSMutableDictionary *allocations = [SanityRules allocations];
    if ([allocations objectForKey:targetClassName]) { // Already observing
        return;
    }
    
    [allocations setObject:@(0) forKey:targetClassName];
    [ASHook hookTarget:target classSelector:@selector(alloc) block:^(__unsafe_unretained id _self) {
        NSNumber *numberOfAllocCalls = [allocations objectForKey:targetClassName];
        if (numberOfAllocCalls) { // Already observing
            NSUInteger increasedNumberOfAllocCalls = [numberOfAllocCalls unsignedIntegerValue] + 1;
            if (increasedNumberOfAllocCalls > maxAllocations) {
                if (failureHandler) {
                    failureHandler(_self);
                } else {
                    assert(false && "Sanity rule has been broken: too many allocations for class.");
                }
            }
            [allocations setObject:@(increasedNumberOfAllocCalls) forKey:targetClassName];
        }
    }];
}

+ (void)startObservingInstanceCountOnClass:(Class)target maxInstanceCount:(NSUInteger)maxInstanceCount failureHandler:(void (^)(__unsafe_unretained id _self))failureHandler {
    assert((target && target == [target class]) && "Plese use a class as the target.");
    NSString *targetClassName = NSStringFromClass(target);
    NSMutableDictionary *instanceCount = [SanityRules instanceCount];
    if ([instanceCount objectForKey:targetClassName]) { // Already observing
        return;
    }
    
    [instanceCount setObject:@(0) forKey:targetClassName];
    [ASHook hookTarget:target classSelector:@selector(alloc) block:^(__unsafe_unretained id _self) {
        NSNumber *numberOfInstances = [instanceCount objectForKey:targetClassName];
        if (numberOfInstances) { // Already observing
            NSUInteger increasedNumberOfInstances = [numberOfInstances unsignedIntegerValue] + 1;
            if (increasedNumberOfInstances > maxInstanceCount) {
                if (failureHandler) {
                    failureHandler(_self);
                } else {
                    assert(false && "Sanity rule has been broken: too many living instances for class.");
                }
            }
            [instanceCount setObject:@(increasedNumberOfInstances) forKey:targetClassName];
        }
    }];
    
    SEL deallocSelector = NSSelectorFromString(@"dealloc"); // Override "ARC forbids using dealloc" error message
    [ASHook hookTarget:target instanceSelector:deallocSelector block:^(__unsafe_unretained id _self) {
        NSNumber *numberOfInstances = [instanceCount objectForKey:targetClassName];
        if (numberOfInstances) { // Already observing
            NSUInteger decreasedNumberOfInstances = MAX([numberOfInstances unsignedIntegerValue] - 1, 0);
            [instanceCount setObject:@(decreasedNumberOfInstances) forKey:targetClassName];
        }
    }];
}

@end
