//
//  DOPDropDownMenu.h
//  DOPDropDownMenuDemo
//
//  Created by weizhou on 9/26/14.
//  Modify by tanyang on 20/3/15.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOPIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger item;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
// default item = -1
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item;
@end

@interface DOPBackgroundCellView : UIView

@end

#pragma mark - data source protocol
@class DOPDropDownMenu;

@protocol DOPDropDownMenuDataSource<NSObject>

@required

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath;

@optional

/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu;

/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;

/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol DOPDropDownMenuDelegate<NSObject>
@optional

/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath;
@end

#pragma mark - interface
@interface DOPDropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<DOPDropDownMenuDataSource>   dataSource;
@property (nonatomic, weak) id<DOPDropDownMenuDelegate>     delegate;

@property (nonatomic, strong) UIColor   *indicatorColor;    // 三角指示器颜色
@property (nonatomic, strong) UIColor   *textColor;         // 文字title颜色
@property (nonatomic, strong) UIColor   *textSelectedColor; // 文字title选中颜色
@property (nonatomic, strong) UIColor   *separatorColor;    // 分割线颜色
@property (nonatomic, assign) NSInteger fontSize;           // 字体大小
// 当有二级列表item时，点击row 是否调用点击代理方法
@property (nonatomic, assign) BOOL isClickHaveItemValid;

/**
 *  是否可下拉（单行菜单）
 */
@property (nonatomic, assign) BOOL isCantDrop;

/**
 *  设置菜单栏文字
 *
 *  @param column
 *  @param string
 */
- (void)setTitleColumn:(NSInteger)column string:(NSString *)string;

- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath;

- (void)selectColumn:(NSInteger)tapIndex;

- (void)hide;

@end
