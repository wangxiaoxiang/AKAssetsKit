//
//  AKAssetsCellCheckbox.m
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/6.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "AKAssetsCellCheckbox.h"

@interface AKAssetsCellCheckbox ()

@property (weak,nonatomic) UILabel* numberLable;

@end

@implementation AKAssetsCellCheckbox
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = self.tintColor.CGColor;
        self.layer.borderWidth = 2;
        
        CGRect label_frame = CGRectMake(CGRectGetWidth(frame)-20, 0, 20, 20);
        UILabel* label = [[UILabel alloc] initWithFrame:label_frame];
        label.backgroundColor = self.tintColor;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font  = [UIFont systemFontOfSize:13];
        label.text = @"0";
        [self addSubview:label];
        self.numberLable = label;
        
        _number = 0;
    }
    return self;
}

-(void)setNumber:(NSUInteger)number
{
    if (_number != number) {
        _number = number;
        self.numberLable.text = @(number).stringValue;
    }
    
}

-(void)tintColorDidChange
{
    [super tintColorDidChange];
    self.layer.borderColor = self.tintColor.CGColor;
    self.numberLable.backgroundColor = self.tintColor;
}
@end
