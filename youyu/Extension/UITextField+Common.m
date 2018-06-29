//
//  UITextField+Common.m
//  BlackCard
//
//  Created by anve on 16/10/13.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import "UITextField+Common.h"

@implementation UITextField (Common)

- (BOOL)textFieldWithRange:(NSRange)range string:(NSString *)string
{
    NSString *text = [self.text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return false;
    }
    
    if (text.length > 18) {
        return false;
    } else if (text.length < 18) {
        NSRange range_x = [text rangeOfString:@"x"];
        NSRange range_X = [text rangeOfString:@"X"];
        if (range_x.location != NSNotFound || range_X.location != NSNotFound) {
            return false;
        }
    }
    
    text = [[text stringByTrimmingCharactersInSet:[characterSet invertedSet]] capitalizedString];
    [self setText:text];
    return false;
}

@end
