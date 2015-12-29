//
//  AKAssetListController_Internal.h
//  AssetsKit
//
//  Created by 汪潇翔 on 15/8/7.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "AKAssetListController.h"

#import "AKAssetsManager.h"
#import "AKOverviewController.h"
#import "AKAssetCell.h"
#import "AKAsset.h"
#import "AssetKit.h"

#import "UIBarButtonItem+AKAssetsKit.h"
#import "UIScrollView+EmptyDataSet.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define SAAssetsCellIdentifier @"SAAssetsCellIdentifier"

@interface AKAssetListController ()<UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout,
                                    DZNEmptyDataSetDelegate,
                                    DZNEmptyDataSetSource>

/*!
 *  @brief  资源过滤
 */
@property (nonatomic, strong) ALAssetsFilter*  assetsFilter;

/*!
 *  @brief  资源组
 */
@property (nonatomic, strong) NSMutableArray* assetsGroups;

/*!
 *  @brief  当前组
 */
@property (nonatomic, strong) ALAssetsGroup* currentGroup;

/*!
 *  @brief  资源库
 */
@property (nonatomic, strong) ALAssetsLibrary* assetsLibrary;

/*!
 *  @brief  相册资源组
 */
@property (nonatomic, strong) NSMutableArray* assetArray;

/*!
 *  @brief  已经选中的选项
 */
@property (nonatomic, strong) NSMutableArray* indexPathsForSelectedItems;

/*!
 *  @brief  主试图
 */
@property (nonatomic, weak)  UICollectionView *collectionView;

/*!
 *  @brief  竖屏布局
 */
@property (nonatomic, strong) UICollectionViewLayout* portraitLayout;

/*!
 *  @brief  横屏布局
 */
@property (nonatomic, strong) UICollectionViewLayout* landscapeLayout;

@end
