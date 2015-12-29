//
//  AKAssetsPickerController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/11/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetsPickerController.h"
#import "AKAssetListController.h"
#import "AKAssetsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AKAssetsPickerController ()<AKAssetListControllerDelegate>

@end

@implementation AKAssetsPickerController
@dynamic delegate;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //判断是否授权，如果用户已经否决。展示否决页面。
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushViewController:[self _assetListController] animated:NO];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pages
- (AKAssetListController*)_assetListController
{
    AKAssetListController* assetListController = [[AKAssetListController alloc] init];
    assetListController.delegate = self;
    return assetListController;
}

- (void)assetListController:(AKAssetListController *)assetListController didFinishPickingMediaWithAssets:(NSArray *)assets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingMediaWithAssets:)]) {
        [self.delegate assetsPickerController:self didFinishPickingMediaWithAssets:assets];
    }
}

- (void)assetListController:(AKAssetListController *)assetListController didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void)assetListControllerDidCancel:(AKAssetListController *)assetListController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
