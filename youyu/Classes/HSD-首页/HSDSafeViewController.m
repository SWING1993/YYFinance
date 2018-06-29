//
//  HSDSafeViewController.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/26.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDSafeViewController.h"
#import "UIViewController+page.h"

@interface HSDSafeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic,copy) NSString *titleText;

@end

@implementation HSDSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Theme backgroundColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.scrollView addSubview:self.imageView];
    self.titleView.title = self.titleText;
}

-(void)setState:(NSInteger)state {
    switch (state) {
        case 0:
            self.image =IMG(@"YYintroduction");
            self.titleText = @"平台简介";
            break;
        case 1:
            self.image =IMG(@"YY_safeIntroduce");
            self.titleText = @"安全保障";
            break;
        default:
            break;
    }
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    [_imageView sizeToFit];
    _imageView.frame = CGRectMake(0, 0, APP_WIDTH, ((APP_WIDTH)/_imageView.frame.size.width) * (_imageView.frame.size.height));
    self.scrollView.contentSize = self.imageView.size;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVHEIGHT)];
        _imageView.backgroundColor = [Theme backgroundColor];
    }
    return _imageView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
