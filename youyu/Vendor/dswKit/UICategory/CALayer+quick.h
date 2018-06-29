//
//  CALayer+quick.h
//  qtyd
//
//  Created by stephendsw on 2017/1/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (quick)

- (void)imageWithName:(NSString *)imageName;

- (void)imageWithURLString:(NSString *)urlstring;

@end
