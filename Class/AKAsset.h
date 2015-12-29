//
//  AKAssets.h
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/6.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface AKAsset : NSObject

@property (nonatomic,strong) UIImage* thumbnail;

@property (nonatomic,assign) BOOL isVideo;

@property (nonatomic,assign) NSUInteger selectedIndex;

@end
