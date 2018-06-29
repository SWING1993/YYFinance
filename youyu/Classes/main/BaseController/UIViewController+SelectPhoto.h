//
//  UIViewController+SelectPhoto.h
//  qtyd
//
//  Created by stephendsw on 16/1/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SelectPhoto)<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

- (void)takePicture;

@end
