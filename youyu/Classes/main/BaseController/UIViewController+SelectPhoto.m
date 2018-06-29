//
//  UIViewController+SelectPhoto.m
//  qtyd
//
//  Created by stephendsw on 16/1/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "UIViewController+SelectPhoto.h"

@implementation UIViewController (SelectPhoto)

- (void)takePicture {
    //	/*注：使用，需要实现以下协议：UIImagePickerControllerDelegate,
    //	 UINavigationControllerDelegate
    //	 */
    //	UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //	//设置图片源(相簿)
    //	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //	//设置代理
    //	picker.delegate = self;
    //	//设置可以编辑
    //	picker.allowsEditing = YES;
    //	//打开拾取器界面
    //	[self presentViewController:picker animated:YES completion:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:@"请选择文件来源"
        delegate                :self
        cancelButtonTitle       :@"取消"
        destructiveButtonTitle  :nil
        otherButtonTitles       :@"照相机", @"照片", nil];

    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // NSLog(@"buttonIndex = [%d]", buttonIndex);
    switch (buttonIndex) {
        case 0:// 照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;

        case 1:// 本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;

        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
