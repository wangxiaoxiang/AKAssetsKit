//
//  SAAssetsViewController.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AKAssetListController;
@protocol AKAssetListControllerDelegate <NSObject>

- (void)assetListController:(AKAssetListController *)assetListController didFinishPickingMediaWithAssets:(NSArray *)assets;

- (void)assetListControllerDidCancel:(AKAssetListController *)assetListController;

@end


@interface AKAssetListController : UIViewController

@property(nonatomic,weak) id<AKAssetListControllerDelegate> delegate;

@end
