//
//  SanityRules.h
//  ASHook
//
//  Created by Adam Szedelyi on 2017. 03. 12..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SanityRules : NSObject

+ (NSMutableDictionary<NSString *, NSNumber *> *)allocations;
+ (NSMutableDictionary<NSString *, NSNumber *> *)instanceCount;

@end
