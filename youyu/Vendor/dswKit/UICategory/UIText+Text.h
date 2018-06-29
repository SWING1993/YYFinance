//
//  UILabel+Text.h
//  qtyd
//
//  Created by stephendsw on 16/4/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Text)

@property (nonatomic, readonly) BOOL isTextEmpty;

@end


@interface UITextField (Text)

@property (nonatomic, readonly) BOOL isTextEmpty;

@property (nonatomic, assign) NSInteger textLimit;

@end

@interface UITextView (Text)

@property (nonatomic, readonly) BOOL isTextEmpty;

@end
