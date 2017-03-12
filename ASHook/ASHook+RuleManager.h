//
//  ASHook+RuleManager.h
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 03. 12..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <ASHook/ASHook.h>

@interface ASHook (RuleManager)

/**
 * Starts observing all allocations for the specified class object (ie. how many times `alloc` has been called).
 *
 * @param target The class object on which the rule will be defined.
 * @param maxAllocations Number of times `alloc` can be called on the class object.
 * @param failureHandler If the rule is broken the failure handler will run.
 *
 */
+ (void)startObservingAllocationsOnClass:(Class)target maxAllocations:(NSUInteger)maxAllocations failureHandler:(void (^)(__unsafe_unretained id _self))failureHandler;

/**
 * Starts observing the count of living instances on the specified class object.
 *
 * @param target The class object on which the rule will be defined.
 * @param maxInstanceCount Number of currently living (ie. allocated but not yet deallocated) instances of the class object.
 * @param failureHandler If the rule is broken the failure handler will run.
 *
 */
+ (void)startObservingInstanceCountOnClass:(Class)target maxInstanceCount:(NSUInteger)maxInstanceCount failureHandler:(void (^)(__unsafe_unretained id _self))failureHandler;

@end
