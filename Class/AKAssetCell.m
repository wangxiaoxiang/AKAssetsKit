//
//  SAAssetsCell.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetCell.h"
#import "AKAssetsCellCheckbox.h"


#if !__has_feature(objc_arc)
#error SAAssetsCell must be built with ARC.
// You can turn on ARC for files by adding -fobjc-arc to the build phase for each of its files.
#endif

@interface AKAssetCell ()

@property (nonatomic, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;

@property (nonatomic, weak) AKAssetsCellCheckbox* checkBox;

@end

@implementation AKAssetCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //ImageView
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        //gesture recognizer
        UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressImage:)];
        thumbnailView.userInteractionEnabled = YES;
        [thumbnailView addGestureRecognizer:longPressGestureRecognizer];
        self.longPressGestureRecognizer = longPressGestureRecognizer;
        
        //check box
        AKAssetsCellCheckbox* checkBox = [[AKAssetsCellCheckbox alloc] initWithFrame:self.contentView.bounds];
        checkBox.userInteractionEnabled = NO;
        checkBox.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        checkBox.hidden = YES;
        [self.contentView addSubview:checkBox];
        self.checkBox = checkBox;
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.checkBox.hidden = YES;
}

-(void)setSelected:(BOOL)selected{
    self.checkBox.hidden = !selected;
    [super setSelected:selected];
    
}

- (void)setIndexNumber:(NSUInteger)indexNumber
{
    self.checkBox.number = indexNumber;
}

- (NSUInteger)indexNumber
{
    return self.checkBox.number;
}

- (void)_longPressImage:(UILongPressGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCell:longPressImage:)]) {
        [self.delegate assetCell:self longPressImage:(UIImageView*)sender.view];
    }
}


@end
