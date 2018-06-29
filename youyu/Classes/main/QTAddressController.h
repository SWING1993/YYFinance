//
//  QTAddressController.h
//  qtyd
//
//  Created by yl on 15/10/8.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@class QTAddressController;
@protocol QTAddressDelagate<NSObject>

- (void)AddressController:(QTAddressController *)controller didSelectAreaId:(NSDictionary *)addressInfo;

@end

@interface QTAddressController : QTBaseViewController
@property (nonatomic, weak) id<QTAddressDelagate> delegate;

@property (nonatomic , assign ) BOOL isSelected;

@end
