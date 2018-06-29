//
//  MenuViewController.m
//  SlideMenu
//
//  Created by dsw on 4/24/13.
//  Copyright (c) 2013 dsw. All rights reserved.
//

#import "MenuViewController.h"
#import "QTMenuCell.h"

@implementation KxMenuItem

+ (instancetype)menuItem:(NSString *)title
                image   :(UIImage *)image
                target  :(id)target
                action  :(SEL)action {
    return [[KxMenuItem alloc] init:title
            image   :image
            target  :target
            action  :action];
}

- (id)  init    :(NSString *)title
        image   :(UIImage *)image
        target  :(id)target
        action  :(SEL)action {
    NSParameterAssert(title.length || image);

    self = [super init];

    if (self) {
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }

    return self;
}

@end

@implementation MenuViewController
{
    UIView *maskView_;
}

+ (instancetype)sharedInstance {
    static MenuViewController   *sharedInstance = nil;
    static dispatch_once_t      predicate;

    dispatch_once(&predicate, ^{
        sharedInstance = [self  controllerFromXib];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = CGRectMake(APP_WIDTH / 2 + 10, 0, APP_WIDTH - APP_WIDTH / 2 + 10, APP_HEIGHT);
    self.view.clipsToBounds = YES;
    self.view.cornerRadius = 10;
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorHex:@"990000"];
    

    self.view.backgroundColor = [UIColor colorHex:@"a62f11" alpha:0.65];

    self.tableView.backgroundColor = [UIColor colorHex:@"a62f11" alpha:0.65];

    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_close_style3"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(APP_WIDTH / 2 - 60, 20, 40, 40);
    [headview addSubview:btn];
    [btn click:^(id value) {
        [self.view removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];

    self.tableView.tableHeaderView = headview;

    self.view.userInteractionEnabled = YES;
}

- (void)initData {
    TABLEReg(QTMenuCell, @"activity_info");
    [self.tableView reloadData];
}

- (void)setMenuItems:(NSArray *)menuItems {
    _menuItems = menuItems;
    [self.tableView reloadData];
}

- (UIView *)maskView {
    if (!maskView_) {
        maskView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
        maskView_.backgroundColor = [UIColor colorWithWhite:137 / 255.0 alpha:0.5];

        WEAKSELF;
        [maskView_ addTapGesture:^{
            [weakSelf.maskView removeFromSuperview];
            [weakSelf.view removeFromSuperview];
        }];
    }

    return maskView_;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"activity_info";
    QTMenuCell      *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    KxMenuItem *item = self.menuItems[indexPath.row];

    [cell bind:item.title];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KxMenuItem *item = self.menuItems[indexPath.row];

    [self.view removeFromSuperview];
    [self.maskView removeFromSuperview];
    SuppressPerformSelectorLeakWarning(
        [self performSelector:item.action]);
}

@end
