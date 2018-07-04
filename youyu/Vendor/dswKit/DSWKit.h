//
//  DSWKit.h
//  test
//
//  Created by stephen on 15/3/5.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#define SuppressPerformSelectorLeakWarning(Stuff)                           \
    do {                                                                    \
        _Pragma("clang diagnostic push")                                    \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff;                                                              \
        _Pragma("clang diagnostic pop")                                     \
    } while (0)

#define NoticePostNetworkError @"notNetwork"

////// Foundation

#import "NSObject+quick.h"
#import "NSArray+Linq.h"
#import "NSDictionary+quick.h"
#import "NSMutableAttributedString+quick.h"

#import "NSDate+quick.h"
#import "NSTimer+block.h"
#import "NSDate+RMCalendarLogic.h"
#import "NSObject+KVO.h"
#import "NSDateFormatter+quick.h"

#import "NSString+Calculation.h"
#import "NSString+regularExpression.h"
#import "NSString+Encry.h"
#import "NSString+Data.h"
#import "NSString+quick.h"
#import "NSString+Time.h"
#import "NSString+URL.h"
#import "NSString+PhoneFormat.h"


#import "UILabel+preview.h"

////// UI

#import "UIControl+BlockEvent.h"
#import "UIControl+Property.h"
#import "UIView+quick.h"
#import "UIAlertView+quick.h"
#import "UIScrollView+contentSize.h"
#import "UIImage+other.h"
#import "UIColor+hexColor.h"
#import "UIViewController+xib.h"
#import "UIViewController+toast.h"
#import "DTableViewCell.h"
#import "UIImageView+webImage.h"
#import "UIText+Text.h"
#import "CALayer+quick.h"
#import "UINavigationController+quick.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "DGridView.h"
#import "DStackView.h"
#import "DWrapView.h"

////// Tool

#import "IPHelper.h"
#import "AppUtil.h"
#import "XHChatQQ.h"
#import "DCodeGenerator.h"
#import "DSandBox.h"

////new Register

#import "HRLoginViewController.h"
