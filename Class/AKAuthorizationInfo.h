//
//  AKAuthorizationInfo.h
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/6.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AKAuthorizationInfo : NSObject

@property (nonatomic,copy,readonly) NSString* message;

@property (nonatomic,assign) ALAuthorizationStatus stauts;

@end
