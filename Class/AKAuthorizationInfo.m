//
//  AKAuthorizationInfo.m
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/6.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "AKAuthorizationInfo.h"

@interface AKAuthorizationInfo ()

@property (nonatomic,copy,readwrite) NSString* message;

@end

@implementation AKAuthorizationInfo

-(instancetype)init
{
    if (self = [super init]) {
        self.stauts = NSNotFound;
    }
    return self;
}

-(void)setStauts:(ALAuthorizationStatus)stauts
{
    _stauts  = stauts;
    switch (stauts) {
        case ALAuthorizationStatusNotDetermined:
            //用户尚未作出选择，为此应用。
            self.message = NSLocalizedString(@"User has not yet made a choice with regards to this application.", nil);
            break;
        case ALAuthorizationStatusRestricted:
            //用户无法更改此应用程序的状态，可能是由于如家长控制中主动限制。
            self.message = NSLocalizedString(@"This application is not authorized to access photo data.The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.", nil);
            break;
        case ALAuthorizationStatusDenied:
            //用户已明确否认了应用访问照片数据。
            self.message = NSLocalizedString(@"User has explicitly denied this application access to photos data.", nil);
            break;
        case ALAuthorizationStatusAuthorized:
            //用户授权该应用程序访问的照片数据。
            break;
        default:
            //未知状态
            self.message = NSLocalizedString(@"Unkown stauts",nil);
            break;
    }
}

@end
