//
//  UILabel+preview.m
//  hr
//
//  Created by 慧融 on 21/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "UILabel+preview.h"

@implementation UILabel (preview)

/**
 *  label内容提示
 */

+ (UILabel*)labelContentPreView:(UITextField*)textField{
   
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor colorHex:@"075dfa"];
    label.backgroundColor = [UIColor colorHex:@"d6e3ff"];
    label.clipsToBounds = YES;
    label.layer.borderColor = [UIColor colorHex:@"d7d7d7"].CGColor;
    label.layer.borderWidth = 0.5f;
    label.layer.cornerRadius = 7.0f;
    
    CGRect frame = textField.frame;
    label.origin = CGPointMake(frame.origin.x,textField.superview.frame.origin.y- 40);
    label.size = CGSizeMake(frame.size.width, 40);
    return label;
}

/**
 *  label内容提示
 */
+ (UILabel*)labelTipInfo:(UITextField*)textField content:(NSString*)str{

    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorHex:@"ff5922"];
    label.backgroundColor = Theme.backgroundColor;
    label.clipsToBounds = YES;
    label.layer.borderColor = [UIColor colorHex:@"ff5922"].CGColor;
    label.layer.borderWidth = 0.5f;
    label.layer.cornerRadius = 3.0f;
    
    CGRect frame = textField.frame;
    label.origin = CGPointMake(frame.origin.x,textField.superview.frame.origin.y- 20);
    label.text = str;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label;

}

//- (void)drawRect:(CGRect)rect {
//    
//    
//    // 默认圆角角度
//    float r = 4;
//    // 居中偏移量(箭头高度)
//    float offset = 5;
//    // 设置 箭头位置
//    float positionNum = 20;
//    
//    
//    // 定义坐标点 移动量
//    float changeNum = r + offset;
//    // 设置画线 长 宽
//    float w = self.frame.size.width ;
//    float h = self.frame.size.height;
//    
//    
//    // 获取文本
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 设置 边线宽度
//    CGContextSetLineWidth(context, 0.2);
//    //边框颜色
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    //矩形填充颜色
//    if ([self.fillColorStr isEqualToString:@"fillColorChange"]) {
//        
//        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//    }else{
//        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    }
//    
//    CGContextMoveToPoint(context, r, offset);  // 开始坐标左边开始
//    CGContextAddArcToPoint(context, w, offset, w, changeNum, r);  // 右上角角度
//    CGContextAddArcToPoint(context, w , h - offset, w - changeNum, h - offset, r);  // 右下角角度
//    
//    CGContextAddLineToPoint(context, positionNum + 10, h - offset); // 向左划线
//    CGContextAddLineToPoint(context, positionNum + 5, h); // 向下斜线
//    CGContextAddLineToPoint(context, positionNum, h - offset); // 向上斜线
//    
//    CGContextAddArcToPoint(context, 0, h - offset, 0, h - changeNum, r); // 左下角角度
//    CGContextAddArcToPoint(context, 0, offset, r, offset, r); // 左上角角度
//    
//    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
//    
//    /** 父类调用 放在画完边线 后.  不然 设置的文字会被覆盖 */
//    [super drawRect:rect];
//    
//}
//
//
//// 当 要改变填充颜色 可以进行调用改变
//-(void)setFillColorStr:(NSString *)fillColorStr{
//    
//    fillColorStr = fillColorStr;
//    
//    // 调用- (void)drawRect:(CGRect)rect; 重绘填充颜色
//    [self setNeedsDisplay];
//   
//}


@end
