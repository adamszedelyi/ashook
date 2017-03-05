//
//  AppDelegate.m
//  ASHookDemo
//
//  Created by Adam Szedelyi on 2017. 03. 05..
//  Copyright © 2017. Adam Szedelyi. All rights reserved.
//

#import "AppDelegate.h"
#import <ASHook/ASHook.h>
#import "EvilSingleton.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    EvilSingleton *anotherOne = [[EvilSingleton alloc] init];
    NSLog(@"Should I use singletons?");
    [ASHook swizzle:anotherOne instanceSelector:@selector(shouldSingletonsBeUsedInAproject) withInstanceSelector:@selector(printNever)];
    [anotherOne shouldSingletonsBeUsedInAproject];
    
    NSLog(@"Should I use singletons?");
    [[EvilSingleton sharedInstance] shouldSingletonsBeUsedInAproject];
}

@end
