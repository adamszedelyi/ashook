//
//  SanityRules.m
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 03. 12..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "SanityRules.h"

static NSMutableDictionary<NSString *, NSNumber *> *asHookAllocations;
static NSMutableDictionary<NSString *, NSNumber *> *asHookInstanceCount;

@implementation SanityRules

+ (void)initialize {
    asHookAllocations = [NSMutableDictionary new];
    asHookInstanceCount = [NSMutableDictionary new];
}

+ (NSMutableDictionary<NSString *, NSNumber *> *)allocations {
    return asHookAllocations;
}

+ (NSMutableDictionary<NSString *, NSNumber *> *)instanceCount {
    return asHookInstanceCount;
}

@end
