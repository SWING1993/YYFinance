//
//  QTSetMsgView.h
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTSetMsgView;

@protocol QTSetMsgViewDelegate <NSObject>

-(void)setMsgView:(QTSetMsgView *)view ;

@end

@interface QTSetMsgView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, assign) BOOL isSelectdAll;

@property (nonatomic , weak ) id<QTSetMsgViewDelegate> delegate;

@end
