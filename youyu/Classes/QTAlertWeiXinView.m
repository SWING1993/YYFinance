//
//  QTAlertWeiXinView.m
//  qtyd
//
//  Created by stephendsw on 16/7/4.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAlertWeiXinView.h"
#import "UIViewController+toast.h"

@interface QTAlertWeiXinView ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView    *imgCode;
@property (weak, nonatomic) IBOutlet UIButton       *btnOk;

@end

@implementation QTAlertWeiXinView

- (void)awakeFromNib {
    [super awakeFromNib];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];

    [self addGestureRecognizer:longTap];

    [self.btnOk click:^(id value) {
        [self.viewController hideCustomHUB];
    }];
}

- (void)imglongTapClick:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:@"保存图片"
            delegate                :self
            cancelButtonTitle       :@"取消"
            destructiveButtonTitle  :nil
            otherButtonTitles       :@"保存图片到手机", nil];

        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

        [actionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.imgCode.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

#pragma mark --- UIActionSheetDelegate---

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [self.viewController showToast:@"成功保存到相册"];
    } else {
        [self.viewController showToast:[error description]];
    }
}

@end
