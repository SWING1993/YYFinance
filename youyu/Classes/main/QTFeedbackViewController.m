//
//  QTFeedbackViewController.m
//  qtyd
//
//  Created by stephendsw on 15/11/9.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTFeedbackViewController.h"
#import "UITextField+input.h"
#import "WTReTextField+Add.h"
#import "QTFeedPhotoView.h"
#import "UIViewController+SelectPhoto.h"

@interface QTFeedbackViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headview;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray<UIButton *> *btns;

@property (strong, nonatomic) IBOutlet UIView               *contentview;
@property (weak, nonatomic) IBOutlet PlaceholderTextView    *tfview;

@property (strong, nonatomic) IBOutlet UILabel *lbH1;

@property (strong, nonatomic) IBOutlet UILabel *lbH2;

@end

@implementation QTFeedbackViewController
{
    UILabel         *lbTip;
    QTFeedPhotoView *photo;
    NSInteger       type;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    [stack addView:self.lbH1 margin:UIEdgeInsetsMake(10, 16, 10, 0)];

    self.headview.backgroundColor = [Theme backgroundColor];
    [stack addView:self.headview margin:UIEdgeInsetsMake(0, 0, 0, 0)];

    [stack addView:self.lbH2 margin:UIEdgeInsetsMake(10, 16, 10, 0)];

    self.contentview.backgroundColor = [Theme backgroundColor];
    self.tfview.layer.cornerRadius = 5;
    self.tfview.placeholder = @"请输入您的宝贵意见";
    [stack addView:self.contentview margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    lbTip = [[UILabel alloc]init];
    lbTip.font = [UIFont systemFontOfSize:12];
    lbTip.textColor = [UIColor lightGrayColor];
    lbTip.textAlignment = NSTextAlignmentRight;
    lbTip.text = @"您还可输入240字";
    [stack addView:lbTip margin:UIEdgeInsetsMake(8, 8, 8, 8)];

    photo = [QTFeedPhotoView viewNib];
    UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    item.backgroundColor = [Theme backgroundColor];
    [item addSubview:photo];

    WEAKSELF;
    [photo addTapGesture:^{
        [weakSelf takePicture];
    }];

    [stack addView:item margin:UIEdgeInsetsMake(0, 0, 0, 0)];

    [stack addRowButtonTitle:@"提交" click:^(id value) {
        if ([NSString isEmpty:self.tfview.text]) {
            [self showToast:@"请输入留言内容"];
        } else {
            [weakSelf commonJson];
        }
    }];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];

    NSInteger i = 1;

    for (UIButton *item in self.btns) {
        item.layer.cornerRadius = 5;
        item.layer.borderColor = [Theme grayColor].CGColor;
        [item setTitleColor:[Theme grayColor] forState:UIControlStateNormal];
        [item setTitleColor:[Theme darkOrangeColor] forState:UIControlStateSelected];
        item.layer.borderWidth = 1;
        item.tag = i;

        [item clickOn:^(id value) {
            for (UIButton *item2 in self.btns) {
                if (![item isEqual:item2]) {
                    item2.selected = NO;
                    item2.layer.borderColor = [Theme grayColor].CGColor;
                } else {
                    item.layer.borderColor = [Theme darkOrangeColor].CGColor;
                    type = item.tag;
                }
            }
        } off:^(id value) {
            item.selected = YES;
            item.layer.borderColor = [Theme darkOrangeColor].CGColor;
        }];

        i++;
    }

    self.btns.firstObject.selected = YES;
    self.btns.firstObject.layer.borderColor = [Theme darkOrangeColor].CGColor;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger length = 240 - textView.text.length;

    if (lbTip.text.length > 240) {
        lbTip.text = [textView.text substringToIndex:240];
    }

    lbTip.text = [NSString stringWithFormat:@"您最多可以输入%lu个字", (unsigned long)length];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [photo setImage:image];
}

#pragma mark - json
- (void)commonJson {
    [self showHUD];

    if (photo.image) {
        NSData *imagedata = UIImagePNGRepresentation([photo.image scaleSizeWithoutScale:CGSizeMake(320, 480)]);
        [service post:@"file_upload" fileUpload:imagedata complete:^(NSDictionary *value) {
            [self commonJsonUp:value.str(@"complete_url")];
        }];
    } else {
        [self commonJsonUp:@""];
    }
}

- (void)commonJsonUp:(NSString *)url {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"back_type"] = @(type);
    dic[@"app_version"] = TRACKID;
    dic[@"img_url"] = url;
    dic[@"back_content"] = self.tfview.text;
    [service post:@"user_feedback" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:@"留言成功，我们会尽快安排人员处理" done:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

@end
