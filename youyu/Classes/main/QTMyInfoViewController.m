//
//  QTMyInfoViewController.m
//  qtyd
//
//  Created by stephendsw on 16/1/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMyInfoViewController.h"
#import "DFormAdd.h"
#import "UIViewController+SelectPhoto.h"

#import "FSMediaPicker.h"
#import "QTSelectAdressViewController.h"

@interface QTMyInfoViewController ()<FSMediaPickerDelegate, SelectAdressDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) WTReTextField *tbNick_name;
@property (nonatomic, strong) WTReTextField *tbIncome;
@property (nonatomic, strong) WTReTextField *tbEducation;
@property (nonatomic, strong) WTReTextField *tbProfessional;
@property (nonatomic, strong) WTReTextField *tbMarriage;
@property (nonatomic, strong) WTReTextField *tbChild;
@property (nonatomic, strong) WTReTextField *tbLinkman;
@property (nonatomic, strong) WTReTextField *tbLink_phone;
@property (nonatomic, strong) WTReTextField *tbYanglao;
@property (nonatomic, strong) WTReTextField *tbRenshou;
@property (nonatomic, strong) UILabel       *tbID_address;
@property (nonatomic, strong) UILabel       *tbAddress;

@end

@implementation QTMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"我的资料";
}

- (void)initUI {
    [self setRefreshScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];

    self.navigationItem.rightBarButtonItem = btn;

    self.imageView.layer.cornerRadius = 22;
    self.imageView.layer.masksToBounds = YES;

    [grid addRowView:self.headView];

    self.tbNick_name = [grid addRowInput:@"昵称" placeholder:@"4-18个字符,只支持中英文和数字"];

    [grid addLineForHeight:20 color:Theme.backgroundColor];
    self.tbIncome = [grid addRowDropText:@"月收入" placeholder:@"请选择"];
    self.tbEducation = [grid addRowDropText:@"最高学历" placeholder:@"请选择"];
    self.tbProfessional = [grid addRowDropText:@"职业类型" placeholder:@"请选择"];
    self.tbMarriage = [grid addRowDropText:@"婚姻状况" placeholder:@"请选择"];
    self.tbChild = [grid addRowDropText:@"有无子女" placeholder:@"请选择"];

    [grid addLineForHeight:20 color:Theme.backgroundColor];

    self.tbLinkman = [grid addRowInput:@"紧急联系人" placeholder:@"-"];
    self.tbLink_phone = [grid addRowInput:@"联系人手机" placeholder:@"-"];
    self.tbYanglao = [grid addRowDropText:@"人寿保险" placeholder:@"请选择"];
    self.tbRenshou = [grid addRowDropText:@"养老保险" placeholder:@"请选择"];
    self.tbID_address = [grid addRowLabel:@"证件地址" text:@"-"];

    WEAKSELF;

    [self.tbID_address addTapGesture:^{
        QTSelectAdressViewController *controller = [QTSelectAdressViewController controllerFromXib];
        controller.tag = 0;
        controller.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    self.tbAddress = [grid addRowLabel:@"居住地址" text:@"-"];
    [self.tbAddress addTapGesture:^{
        QTSelectAdressViewController *controller = [QTSelectAdressViewController controllerFromXib];
        controller.tag = 1;
        controller.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    [grid addLineForHeight:20 color:Theme.backgroundColor];
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];

    // 外观配置
    for (UIView *item in grid.allSubviews) {
        if ([item isKindOfClass:[WTReTextField class]]) {
            ((WTReTextField *)item).textAlignment = NSTextAlignmentRight;
            ((WTReTextField *)item).textColor = Theme.darkGrayColor;
        }
    }

    for (UIView *item in grid.allSubviews) {
        if ([item isKindOfClass:[UITextView class]]) {
            ((UITextView *)item).textAlignment = NSTextAlignmentRight;
            ((UITextView *)item).textColor = Theme.darkGrayColor;
        }
    }

    for (UIView *item in grid.allSubviews) {
        if ([item isKindOfClass:[UILabel class]]) {
            ((UILabel *)item).textColor = [UIColor blackColor];
        }
    }

    self.tbAddress.textColor = Theme.darkGrayColor;
    self.tbID_address.textColor = Theme.darkGrayColor;
}

- (void)initData {
    self.isLockPage = YES;
    self.imageView.image = [UIImage imageNamed:@"iconfont_morentouxiang"];

    [self.imageView addTapGesture:^{
        FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeCircular;
        mediaPicker.delegate = self;
        [mediaPicker showFromView:self.view];
    }];

    [self showHUD];
    [self commonJson];

    [self.tbLink_phone setPhone];
    self.tbLink_phone.isNeed = NO;
    self.tbLink_phone.group = 0;
}

- (void)selectedAddress:(NSString *)value tag:(NSInteger)tag {
    if (tag == 0) {
        self.tbID_address.text = value;
    } else {
        self.tbAddress.text = value;
    }

    [self.scrollview autoContentSize];
}

#pragma mark -delegate
- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo {
    if (mediaInfo.mediaType == FSMediaTypePhoto) {
        self.imageView.image = mediaInfo.circularEditedImage;
    }
}

#pragma mark - event
- (void)save {
    if (![self.view validation:0]) {
        return;
    }

    [self commonJsonSave];
}

#pragma mark - json

- (void)commonJson {
    [service post:@"user_infodtl" data:nil complete:^(NSDictionary *value) {
        self.tbNick_name.text = value.str(@"nick_name");
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:value.str(@"app_litpic")] placeholderImage:[UIImage imageNamed:@"iconfont_morentouxiang"]];
        self.tbIncome.text = value.str(@"income");
        self.tbEducation.text = value.str(@"education");
        self.tbProfessional.text = value.str(@"professional");
        self.tbMarriage.text = value.str(@"marry");
        self.tbChild.text = value.str(@"child");
        self.tbLinkman.text = value.str(@"linkman");
        self.tbLink_phone.text = value.str(@"phone");
        self.tbYanglao.text = value.str(@"yanglao");
        self.tbRenshou.text = value.str(@"renshou");
        self.tbAddress.text = value.str(@"address");
        self.tbID_address.text = value.str(@"id_address");

        [self.scrollview autoContentSize];
        [super commonJson];
        [self hideHUD];
    }];

    [service post:@"user_infocfg" data:nil complete:^(NSDictionary *value) {
        [self.tbIncome setInputDropList:[value.arr(@"user_income") getArrayForKey:@"val"]];
        [self.tbEducation setInputDropList:[value.arr(@"user_education") getArrayForKey:@"val"]];
        [self.tbProfessional setInputDropList:[value.arr(@"user_company_office") getArrayForKey:@"val"]];
        [self.tbMarriage setInputDropList:[value.arr(@"user_marry") getArrayForKey:@"val"]];
        [self.tbChild setInputDropList:[value.arr(@"user_child") getArrayForKey:@"val"]];
        [self.tbRenshou setInputDropList:[value.arr(@"user_renshou") getArrayForKey:@"val"]];
        [self.tbYanglao setInputDropList:[value.arr(@"user_yanglao") getArrayForKey:@"val"]];
        [super commonJson];
    }];
}

- (void)commonJsonSave {
    [self showHUD];
    UIImage *image = self.imageView.image;
    image = [image scaleSizeWithoutScale:CGSizeMake(100, 100)];

    NSData *imageData = UIImagePNGRepresentation(image);

    [service post:@"file_upload" fileUpload:imageData complete:^(NSDictionary *value) {
        NSMutableDictionary *dic = [NSMutableDictionary new];

        dic[@"nick_name"] = self.tbNick_name.text;
        dic[@"img_url"] = value[@"complete_url"];
        dic[@"marriage"] = self.tbMarriage.text;
        dic[@"child"] = self.tbChild.text;
        dic[@"yanglao"] = self.tbYanglao.text;
        dic[@"renshou"] = self.tbRenshou.text;
        dic[@"education"] = self.tbEducation.text;
        dic[@"id_address"] = self.tbID_address.text;
        dic[@"address"] = self.tbAddress.text;
        dic[@"income"] = self.tbIncome.text;
        dic[@"professional"] = self.tbProfessional.text;
        dic[@"linkman"] = self.tbLinkman.text;
        dic[@"link_phone"] = self.tbLink_phone.text;

        [service post:@"user_infoedit" data:dic complete:^(NSDictionary *value) {
            [self hideHUD];
            [GVUserDefaults  shareInstance].nick_name = self.tbNick_name.text;
            [GVUserDefaults  shareInstance].app_litpic = dic[@"img_url"];
            [[GVUserDefaults  shareInstance] saveLocal];
            [self showToast:@"保存成功"];
        }];
    }];
}

@end
