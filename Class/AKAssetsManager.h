//
//  AKAssetsManager.h
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/4.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKAuthorizationInfo.h"

FOUNDATION_EXTERN NSAttributedString* messageWithAuthorizationStauts(ALAuthorizationStatus stauts);
@interface AKAssetsManager : NSObject

@property (nonatomic,strong) AKAuthorizationInfo* authorizationInfo;

+(instancetype)sharedInstance;


@end


