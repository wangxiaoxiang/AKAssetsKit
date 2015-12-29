//
//  SAAssetsViewController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetListController.h"
#import "AKAssetListController_Internal.h"

#if !__has_feature(objc_arc)
#error SAAssetsViewController must be built with ARC.
// You can turn on ARC for files by adding -fobjc-arc to the build phase for each of its files.
#endif

typedef void(^AKFetchGroupFinishBlock)(NSArray* groups,NSError* error);

typedef void(^AKFetchAssetsFinishBlock)(NSArray* assets);

inline NSAttributedString* messageWithAuthorizationStauts(ALAuthorizationStatus stauts)
{
    NSString* message = nil;
    switch (stauts) {
        case ALAuthorizationStatusNotDetermined:
            //用户尚未作出选择，为此应用。
            message = AKLocalizedString(@"User has not yet made a choice with regards to this application.", nil);
            break;
        case ALAuthorizationStatusRestricted:
            //用户无法更改此应用程序的状态，可能是由于如家长控制中主动限制。
            message = AKLocalizedString(@"This application is not authorized to access photo data.The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.", nil);
            break;
        case ALAuthorizationStatusDenied:
            //用户已明确否认了应用访问照片数据。
            message = AKLocalizedString(@"User has explicitly denied this application access to photos data.", nil);
            break;
        case ALAuthorizationStatusAuthorized:
            //用户授权该应用程序访问的照片数据。
            message = AKLocalizedString(@"User has authorized this application to access photos data.", nil);
            break;
        default:
            //未知状态
            message = AKLocalizedString(@"Unkown stauts",nil);
            break;
    }
    return [[NSAttributedString alloc] initWithString:message];
}

NSAttributedString* buttonTitleWithAuthorizationStauts(ALAuthorizationStatus stauts,UIColor* tintColor,UIControlState state)
{
    NSAttributedString* title = nil;
    UIColor* foregroundColor = state == UIControlStateHighlighted?[UIColor lightGrayColor]:tintColor;
    NSDictionary* attributes = @{NSForegroundColorAttributeName:foregroundColor};
    switch (stauts) {
        case ALAuthorizationStatusNotDetermined:
            //用户尚未作出选择，为此应用。
            title = [[NSAttributedString alloc] initWithString:AKLocalizedString(@"Authorization", nil)
                                                    attributes:attributes];
            break;
        case ALAuthorizationStatusDenied:
            //用户已明确否认了应用访问照片数据。
            title = [[NSAttributedString alloc] initWithString:AKLocalizedString(@"Reauthorization", nil)
                                                    attributes:attributes];
            break;
        case ALAuthorizationStatusAuthorized:
            //用户授权该应用程序访问的照片数据。
            title = [[NSAttributedString alloc] initWithString:AKLocalizedString(@"Reload", nil)
                                                    attributes:attributes];
            break;
        case ALAuthorizationStatusRestricted:
            //用户无法更改此应用程序的状态，可能是由于如家长控制中主动限制。
        default:
            //未知状态
            break;
    }
    return title;
}

bool deviceIsPortrait()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

@implementation AKAssetListController

#pragma mark - Override function
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.assetsGroups = [NSMutableArray new];
        self.assetsLibrary = [ALAssetsLibrary new];
        self.indexPathsForSelectedItems = [NSMutableArray new];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
//    NSLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
    [self _initLayout];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:deviceIsPortrait()?self.portraitLayout:self.landscapeLayout];
    
    NSInteger autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    collectionView.autoresizingMask = autoresizingMask;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.allowsMultipleSelection = YES;
    
    [collectionView registerClass:[AKAssetCell class] forCellWithReuseIdentifier:SAAssetsCellIdentifier];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem AK_cancelButtonItem:self
                                                                           action:@selector(_cancel:)];
    
    UIBarButtonItem* confirmButtonItem = [UIBarButtonItem AK_confirmButtonItem:self
                                                                         action:@selector(_confirm:)];
    
    UIBarButtonItem* cameraButtonItem = [UIBarButtonItem AK_cameraButtonItem:self
                                                                      action:@selector(_takeCamera:)];
    
    UIBarButtonItem* flexibleSpaceButtonItem = [UIBarButtonItem AK_flexibleSpaceButtonItem];
    self.toolbarItems = @[cameraButtonItem,flexibleSpaceButtonItem,confirmButtonItem];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取数据
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status!=ALAuthorizationStatusAuthorized) {
        [self.collectionView reloadEmptyDataSet];
    }else{
        [self _fetchAssets];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UICollectionViewLayout* layout = deviceIsPortrait()?self.portraitLayout:self.landscapeLayout;
    if (layout != self.collectionView.collectionViewLayout) {
        self.collectionView.collectionViewLayout = layout;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)_initLayout
{
    
    UICollectionViewFlowLayout* portraitLayout = [UICollectionViewFlowLayout new];
    portraitLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    portraitLayout.minimumInteritemSpacing = 2.0f;
    portraitLayout.minimumLineSpacing = 2.0f;
    
    
    UICollectionViewFlowLayout* landscapeLayout = [UICollectionViewFlowLayout new];
    landscapeLayout.sectionInset = UIEdgeInsetsMake(10, 2, 10, 2);
    landscapeLayout.minimumInteritemSpacing = 2.0f;
    landscapeLayout.minimumLineSpacing = 2.0f;
    
    CGFloat width   = CGRectGetWidth(self.view.bounds);
    CGFloat height  = CGRectGetHeight(self.view.bounds);
    
    CGFloat portraitItemWH   = 0;
    CGFloat landscapeItemWH  = 0;

    if (deviceIsPortrait()) {
        portraitItemWH = (width-2*3)/4;
        landscapeItemWH = (height-2*8)/7;
    }else{
        portraitItemWH = (height-2*3)/4;;
        landscapeItemWH = (width-2*8)/7;
    }
    

    portraitLayout.itemSize = CGSizeMake(portraitItemWH, portraitItemWH);
    landscapeLayout.itemSize = CGSizeMake(landscapeItemWH, landscapeItemWH);
    
    self.portraitLayout = portraitLayout;
    self.landscapeLayout = landscapeLayout;
}
#pragma mark - Fetch assets
-(void)_fetchAssets{
    
    __weak typeof(self) weakSelf = self;
    //获取资源组错误的回调
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
    };
    //获取资源组成功的回调
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop/*如果你把stop指针设置为Yes,枚举将结束*/){
        if (group){
            [weakSelf.assetsGroups addObject:group];
        }else{
            if (self.assetsGroups.count > 0) {
                ALAssetsGroup* group = [weakSelf.assetsGroups firstObject];
                NSMutableArray* assetArray = [NSMutableArray arrayWithCapacity:group.numberOfAssets];
                ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        AKAsset* asset  = [AKAsset new];
                        asset.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                        [assetArray addObject:asset];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.assetArray = [assetArray mutableCopy];
                            weakSelf.navigationItem.title = [group valueForProperty:ALAssetsGroupPropertyName];
                            [weakSelf.collectionView reloadData];
                        });
                    }
                };
                
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
    };
    
    ALAssetsLibrary* assetsLibrary = self.assetsLibrary;
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                 usingBlock:listGroupBlock
                               failureBlock:failureBlock];
}

- (void)_fetchGroupWithLibrary:(ALAssetsLibrary*)library
                   finishBlock:(AKFetchGroupFinishBlock)finishBlock
{
    AKFetchGroupFinishBlock cp_finishBlock = [finishBlock copy];
    //获取资源组错误的回调
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        cp_finishBlock(nil,error);
    };
    NSMutableArray* groups = [NSMutableArray new];
    ALAssetsLibraryGroupsEnumerationResultsBlock enumerationGroupBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [groups addObject:group];
        }else{
            cp_finishBlock(groups,nil);
        }
    };
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:enumerationGroupBlock
                         failureBlock:failureBlock];
    
}

- (void)_fetchAssetsWithGroup:(ALAssetsGroup*)group
                 assetsFilter:(ALAssetsFilter*)assetsFilter
                  finishBlock:(AKFetchAssetsFinishBlock)finishBlock
{
    AKFetchAssetsFinishBlock cp_finishBlock = [finishBlock copy];
    if (group) {
        //设置过滤器
        if (assetsFilter) {
            [group setAssetsFilter:assetsFilter];
        }
        //获取内容
        NSMutableArray* assets = [NSMutableArray arrayWithCapacity:group.numberOfAssets];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                AKAsset* asset  = [AKAsset new];
                asset.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                [assets addObject:asset];
            }else{
               cp_finishBlock(assets);
            }
        };
        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }else{
        cp_finishBlock(nil);
    }
}

#pragma mark - UICollectionView data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.assetArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AKAssetCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SAAssetsCellIdentifier
                                                                   forIndexPath:indexPath];
    AKAsset* asset = self.assetArray[indexPath.row];
    cell.indexNumber = asset.selectedIndex;
    cell.thumbnailView.image = asset.thumbnail;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1,2,3,4
    //如果取消了2，那3、4都要刷新
    NSUInteger index  = [self.indexPathsForSelectedItems indexOfObject:indexPath];
    [self.indexPathsForSelectedItems removeObject:indexPath];
    
    
    while (index<self.indexPathsForSelectedItems.count) {
        NSIndexPath* indexPath = self.indexPathsForSelectedItems[index];
        AKAssetCell* cell = (AKAssetCell*)[collectionView cellForItemAtIndexPath:indexPath];
        AKAsset* asset = self.assetArray[indexPath.row];
        asset.selectedIndex = 0;
        cell.indexNumber = ++index;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger maxCount = 10;
    if (self.indexPathsForSelectedItems.count < maxCount) {
        return YES;
    }else{
        //
        NSString* message = [NSString stringWithFormat:AKLocalizedString(@"最多允许选择%zi张照片😝", nil),maxCount];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:AKLocalizedString(@"知道了", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKAssetCell* cell = (AKAssetCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.indexNumber = self.indexPathsForSelectedItems.count+1;
    AKAsset* asset = self.assetArray[indexPath.row];
    asset.selectedIndex = cell.indexNumber;
    [self.indexPathsForSelectedItems addObject:indexPath];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    return messageWithAuthorizationStauts([ALAssetsLibrary authorizationStatus]);
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return buttonTitleWithAuthorizationStauts([ALAssetsLibrary authorizationStatus],scrollView.tintColor,state);
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    switch ([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusDenied:
            //用户已明确否认了应用访问照片数据。
            [self _openSettings];
            break;
        case ALAuthorizationStatusNotDetermined:
            //用户尚未作出选择，为此应用。
        case ALAuthorizationStatusAuthorized:
            [self _fetchAssets];
            //用户授权该应用程序访问的照片数据。
            break;
        default:
            //未知状态
            break;
    }
}
- (void)_openSettings
{
    NSLog(@"%@",UIApplicationOpenSettingsURLString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - Actions
-(void)_cancel:(UIBarButtonItem*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetListControllerDidCancel:)]) {
        [self.delegate assetListControllerDidCancel:self];
    }
}

-(void)_takeCamera:(UIBarButtonItem*)sender{

    
}
-(void)_confirm:(UIBarButtonItem*)sender{
    
}

@end
