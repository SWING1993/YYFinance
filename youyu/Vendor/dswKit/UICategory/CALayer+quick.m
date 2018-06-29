//
//  CALayer+quick.m
//  qtyd
//
//  Created by stephendsw on 2017/1/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "CALayer+quick.h"

@implementation CALayer (quick)

- (void)imageWithName:(NSString *)imageName {
    self.contents = (__bridge id)[UIImage imageNamed:imageName].CGImage;
}

- (void)imageWithURLString:(NSString *)urlstring  {
    self.contents = (__bridge id)[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]]].CGImage;
}

@end
