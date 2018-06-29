//
//  QTAnnouncementViewController.h
//  qtyd
//
//  Created by yl on 15/11/2.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

typedef NS_ENUM (NSInteger, QTAnnouncement) {
    // 以下是枚举成员
    QTAnnouncementMedia = 0,
    QTAnnouncementNotice = 1,
    QTAnnouncementNews = 2,
};

@interface QTAnnouncementViewController : QTBaseViewController

@property (nonatomic, assign) IBInspectable QTAnnouncement type;

@property (nonatomic, strong)  NSString *sort;
@end
