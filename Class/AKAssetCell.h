//
//  SAAssetsCell.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AKAssetCell;
@protocol AKAssetCellDelegate <NSObject>

-(void)assetCell:(AKAssetCell*)assetCell longPressImage:(UIImageView*)imageView;

@end

@interface AKAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *thumbnailView;

@property (weak, nonatomic) id<AKAssetCellDelegate> delegate;

@property (nonatomic) NSUInteger indexNumber;

@end
