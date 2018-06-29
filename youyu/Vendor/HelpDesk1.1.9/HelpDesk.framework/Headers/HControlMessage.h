//
//  HControlMessage.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HCompositeContent.h"
#import "HContent.h"

FOUNDATION_EXPORT NSString * const TYPE_EVAL_REQUEST;
FOUNDATION_EXPORT NSString * const TYPE_EVAL_RESPONSE;
FOUNDATION_EXPORT NSString * const TYPE_TRANSFER_TO_AGENT;


@interface ControlType : HContent

@property (nonatomic, copy) NSString * ctrlType;

-(instancetype) initWithValue:(NSString *)value;

@end

@interface ControlArguments : HContent
@property (nonatomic, copy) NSString* identity;
@property (nonatomic, copy) NSString* sessionId;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* detail;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, copy) NSString* inviteId;
@end

@interface HControlMessage : HCompositeContent

@property (nonatomic, strong) ControlType *type;
@property (nonatomic, strong) ControlArguments *arguments;

@end

