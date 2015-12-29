//
//  AKAssetsManager.m
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/4.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "AKAssetsManager.h"
#import <UIKit/UIApplication.h>

@implementation AKAssetsManager


+ (instancetype)sharedInstance
{
    static AKAssetsManager* assetsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsManager = [[AKAssetsManager alloc] init];
    });
    return assetsManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.authorizationInfo = [AKAuthorizationInfo new];
        self.authorizationInfo.stauts = [ALAssetsLibrary authorizationStatus];
        //后台启动通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        //相册改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_assetsLibraryChanged:)
                                                     name:ALAssetsLibraryChangedNotification
                                                   object:nil];
    }
    return self;
}

-(void)_assetsLibraryChanged:(NSNotification*)note
{
    NSLog(@"note:%@",note);
}

-(void)_applicationDidBecomeActiveNotification:(NSNotification*)note
{
    self.authorizationInfo.stauts = [ALAssetsLibrary authorizationStatus];
}
@end
