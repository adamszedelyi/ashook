//
//  ASHookTests.m
//  ASHookTests
//
//  Created by Adam Szedelyi on 2017. 02. 26..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ASHook/ASHook.h>

@interface ASHookTests : XCTestCase

@property (nonatomic, assign) BOOL classMethodCalled;

@end

@implementation ASHookTests

- (void)setUp {
    [super setUp];
    _classMethodCalled = NO;
}

- (void)testSwizzleInstanceSelector {
    XCTAssert([self two] - [self one] == 1, @"Two minus one equals one.");
    [ASHook swizzle:self instanceSelector:@selector(one) withInstanceSelector:@selector(two)];
    XCTAssert([self one] - [self two] == 1, @"One and two should've been replaced.");
}

- (void)testHookClassSelector {
    XCTAssert(self.classMethodCalled == NO, @"The class selector hasn't been called yet.");
    __weak ASHookTests *weakSelf = self;
    [ASHook runBlock:^(__unsafe_unretained id _self) {
        weakSelf.classMethodCalled = YES;
    } onTarget:self beforeClassSelector:@selector(aClassMethod)];
    [self.class aClassMethod];
    XCTAssert(self.classMethodCalled, @"The class selector has been called.");
}

#pragma mark - Private helpers

- (NSUInteger)one {
    return 1;
}

- (NSUInteger)two {
    return 2;
}

+ (void)aClassMethod {
    // Body of a class method
}

@end
