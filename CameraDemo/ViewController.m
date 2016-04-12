//
//  ViewController.m
//  CameraDemo
//
//  Created by 樊琳琳 on 16/4/12.
//  Copyright © 2016年 fll. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *photoButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 40, 100, 100)];
    photoButton.backgroundColor=[UIColor grayColor];
    [photoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 100, 100)];
    _imageView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_imageView];
}
-(void)photoClick
{

//    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *destructiveButtonTitle = NSLocalizedString(@"照相", nil);
    NSString *pictureTitle=NSLocalizedString(@"相册", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    }];
    
    //相册
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:pictureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:destructiveAction];
    [alertController addAction:pictureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.navigationBar.tintColor = NavItemBlackGroundColor;
    //    picker.navigationBar.barTintColor = NavItemBlackGroundColor;
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont systemFontOfSize:15.5],NSFontAttributeName,
                                    nil,NSShadowAttributeName,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    picker.delegate = self;
    picker.allowsEditing  = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *aimage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [self imageWithImage:aimage scaledToSize:0.2];//压缩图片

    _imageView.image=image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);//保存图片到相册
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存图片结果提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
