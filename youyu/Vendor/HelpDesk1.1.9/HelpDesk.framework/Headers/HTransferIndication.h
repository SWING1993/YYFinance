//
//  HTransferIndication.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HCompositeContent.h"
#import "HContent.h"
#import "HAgentInfo.h"

@interface Event: HContent
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* obj;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end

@interface HTransferIndication : HCompositeContent
@property (nonatomic, strong) HAgentInfo * agentInfo;
@property (nonatomic, strong) Event *event;
-(instancetype) initWithContents:(NSMutableDictionary *)obj;
@end


