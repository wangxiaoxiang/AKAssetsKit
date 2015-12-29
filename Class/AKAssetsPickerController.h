//
//  AKAssetsPickerController.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/11/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKAssetsPickerController;
@protocol AKAssetsPickerControllerDelegate <UINavigationControllerDelegate>

- (void)assetsPickerController:(AKAssetsPickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets;

- (void)assetsPickerControllerDidCancel:(AKAssetsPickerController *)picker;

@end

@interface AKAssetsPickerController : UINavigationController

/*
 *  最大选择数量
 */
@property (nonatomic,assign) NSUInteger maxSelectionCount;

@property (nonatomic,assign) id<AKAssetsPickerControllerDelegate> delegate;

@end
