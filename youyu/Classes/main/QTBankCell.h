//
//  QTBankCell.h
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"


@protocol QTBankCellDelegate <NSObject>

-(void)BankVerified:(NSString *)cardID;

-(void)BankUpdate:(NSString *)toast;

@end


@interface QTBankCell : DTableViewCell


@property (nonatomic , assign ) BOOL  is_verified;

@property (nonatomic , weak ) id<QTBankCellDelegate> bankdelegate;

@property (nonatomic , assign ) BOOL isUpdate;

@end
