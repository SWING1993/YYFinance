//
//  WMPageController.m
//  WMPageController
//
//  Created by dsw on 15/6/11.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "WMPageController.h"
#import "AppUtil.h"
#import "UIView+layout.h"
#import "UIViewExt.h"
#import "UIColor+hexColor.h"

@interface WMPageController ()<WMMenuViewDelegate, UIScrollViewDelegate>{
    CGFloat viewHeight;
    CGFloat viewWidth;
    CGFloat targetX;
}

@property (nonatomic, strong, readwrite) UIViewController *currentViewController;

@property (nonatomic, weak) UIScrollView *scrollView;

// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;

@end

@implementation WMPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

// 子类重写
- (void)setupNavigationItems {
    [super setupNavigationItems];
    if (self.isMenuInTop) {
        self.menuView.centerX = APP_WIDTH / 2;
        self.menuView.centerY = 44 / 2;
        
        self.navigationItem.titleView = self.menuView;
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self resetMenuView];
    [self menuView:self.menuView didSelesctedIndex:self.selectIndex currentIndex:self.selectIndex];
}

- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles {
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];

        [self setup];
    }

    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }

    return self;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = [itemsWidths copy];
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;

    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;

    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)addMenuView {
    [self.menuView removeFromSuperview];

    CGRect frame;

    if (self.isMenuInTop) {
        frame = CGRectMake(0, 0, 200, 30);
    } else {
        frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
    }

    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];

    menuView.delegate = self;
    menuView.style = self.menuViewStyle;

    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }

    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }

    if (!self.isMenuInTop) {
        [self.view addSubview:menuView];
    }

    [self.view sendSubviewToBack:menuView];

    if (!self.isMenuInTop) {
        [menuView setBottomLine:[UIColor colorHex:@"e6e6e6"]];
    }

    self.menuView = menuView;

    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
}

- (void)calculateSize {
    if (self.isMenuInTop) {
        viewHeight = APP_HEIGHT - 20 - self.tabBarController.tabBar.height - self.navigationController.navigationBar.height - _cutHeight;
    } else {
        viewHeight = APP_HEIGHT - APP_NAVHEIGHT - self.menuHeight - self.tabBarController.tabBar.height - _cutHeight;
    }

    viewHeight -= self.bottomHeight;

    if (self.delegate && [self.delegate respondsToSelector:@selector(WMPageControllerAddBottomView:)]) {
        UIView *view = [self.delegate WMPageControllerAddBottomView:self];
        view.bottom = self.view.height;
        view.width = APP_WIDTH;
        view.layer.cornerRadius = 0;
        [self.view addSubview:view];
    }

    viewWidth = self.view.frame.size.width;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];

    for (int i = 0; i < self.viewControllerClasses.count; i++) {
        CGRect frame = CGRectMake(i * viewWidth, 0, viewWidth, viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

// 添加子控制器
- (void)addViewControllerAtIndex:(int)index {
    UIViewController *controller = self.viewControllerClasses[index];

    [self addChildViewController:controller];
    controller.view.frame = [self.childViewFrames[index] CGRectValue];
    [controller didMoveToParentViewController:self];
    [controller viewWillAppear:YES];
    [self.scrollView addSubview:controller.view];
}

- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / viewWidth;

    if (self.scrollView.contentOffset.x / viewWidth - currentPage > 0.99) {
        currentPage += 1;
    }

    if (self.viewControllerClasses[currentPage].view.superview == nil) {
        [self addViewControllerAtIndex:currentPage];
    }
}

// 初始化一些参数，在init中调用
- (void)setup {
    _titleSizeSelected = 13;
    _titleColorSelected = [UIColor colorWithRed:168.0 / 255.0 green:20.0 / 255.0 blue:4 / 255.0 alpha:1];
    _titleSizeNormal = 12;
    _titleColorNormal = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    _menuBGColor = [UIColor colorWithRed:244.0 / 255.0 green:244.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
    _menuHeight = 30.0f;
    _menuItemWidth = 65.0f;
}

- (void)loadData {
    if (self.viewControllerClasses.count > 0) {
        [self.scrollView removeFromSuperview];

        UIScrollView *scrollView = [[UIScrollView alloc] init];

        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;

        [self.view addSubview:scrollView];
        self.scrollView = scrollView;

        [self calculateSize];

        [self addMenuView];

        CGFloat top = self.menuHeight;

        if (self.isMenuInTop) {
            top = 0;
        }

        CGRect scrollFrame = CGRectMake(0, top, viewWidth, viewHeight);
        self.scrollView.frame = scrollFrame;
        self.scrollView.contentSize = CGSizeMake(self.titles.count * viewWidth, viewHeight);
        [self.scrollView setContentOffset:CGPointMake(self.selectIndex * viewWidth, 0)];

        self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];

        [self layoutChildViewControllers];

        [self addViewControllerAtIndex:self.selectIndex];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat rate = contentOffsetX / viewWidth;

    [self.menuView slideMenuAtProgress:rate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / viewWidth;
    self.currentViewController = self.viewControllerClasses[self.selectIndex];
    [self.currentViewController viewWillAppear:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = targetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    CGPoint targetP = CGPointMake(viewWidth * index, 0);

    [self.scrollView setContentOffset:targetP animated:NO];

    _selectIndex = (int)index;
    self.currentViewController = self.viewControllerClasses[self.selectIndex];
    [self.currentViewController viewWillAppear:YES];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }

    return self.menuItemWidth;
}

@end
