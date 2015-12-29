//
//  ViewController.m
//  AssetsKit
//
//  Created by wangxiaoxiang on 15/3/12.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "ViewController.h"
#import "AKAssetsPickerController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)assets:(id)sender {
    AKAssetsPickerController*  assetsPickerController = [[AKAssetsPickerController alloc] init];
    [self presentViewController:assetsPickerController animated:YES completion:nil];
}
- (IBAction)showImagePicker:(id)sender {
    
    UIImagePickerController* imp = [[UIImagePickerController alloc] init];
    imp.allowsEditing = YES;
    imp.delegate = self;
    [self presentViewController:imp animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
