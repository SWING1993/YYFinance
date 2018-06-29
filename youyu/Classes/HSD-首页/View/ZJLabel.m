//
//  ZJLabel.m
//  ZJLabel
//
//  Created by iOS on 16/6/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ZJLabel.h"
@interface ZJLabel ()

@property (nonatomic,strong)NSTimer * myTimer;

@property (nonatomic,assign) CGRect MYframe;

@property (nonatomic,assign) CGFloat fa;

@property (nonatomic,assign) CGFloat bigNumber;

@end
@implementation ZJLabel
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _MYframe = frame;
        self.backgroundColor = [UIColor clearColor];
        UILabel * presentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        presentLabel.textAlignment = 1;
        presentLabel.textColor = RGBA(244, 58, 70, 1);
        [self addSubview:presentLabel];
        self.presentlabel = presentLabel;
        self.presentlabel.font = [UIFont systemFontOfSize:35];
        self.decimalsCount = YES;
      
    }
    return self;
}

- (void)createTimer{

    if (!self.myTimer) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    [self.myTimer setFireDate:[NSDate distantPast]];
}
- (void)action{
    //让波浪移动效果
        _fa = _fa+10;
    if (_fa >= _MYframe.size.width * 2.0) {
        _fa = 0;
    }
    [self setNeedsDisplay];
 }
- (void)drawRect:(CGRect)rect{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    UIColor * blue = RGBA(244, 58, 70, 0.3);
    CGContextSetFillColorWithColor(context, [blue CGColor]);
    
    float y= (1 - self.present) * rect.size.height;
     float y1= (1 - self.present) * rect.size.height;

    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=rect.size.width * 3.0;x++){
//正弦函数
        y=  sin( x/rect.size.width * M_PI + _fa/rect.size.width *M_PI ) *_bigNumber + (1 - self.present) * rect.size.height ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height );
    CGPathAddLineToPoint(path, nil, 0, rect.size.height );
   // CGPathAddLineToPoint(path, nil, 0, 200);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);

   
    CGMutablePathRef path1 = CGPathCreateMutable();
  //  float y1=200;
    //画水
    CGContextSetLineWidth(context, 1);
    UIColor * blue1 =RGBA(255, 120, 126, 1.0);
    CGContextSetFillColorWithColor(context, [blue1 CGColor]);
    
   
  //  float y1= 200;
    CGPathMoveToPoint(path1, NULL, 0, y1);
    for(float x=0;x<=rect.size.width;x++){

        y1= sin( x/rect.size.width * M_PI + _fa/rect.size.width *M_PI  +M_PI ) *_bigNumber + (1 - self.present) * rect.size.height ;
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    
    CGPathAddLineToPoint(path1, nil, rect.size.height, rect.size.width );
    CGPathAddLineToPoint(path1, nil, 0, rect.size.height );
    //CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path1);
    NSString *str;
    if (!self.decimalsCount) {
        str = [NSString stringWithFormat:@"%g%%",self.present * 100];
    }else{
        str = [NSString stringWithFormat:@"%.1f%%",self.present * 100.0];
    }
    //添加文字
    
    
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];

    // 需要改变的区间
    NSRange range = NSMakeRange([str length] - 1, 1);
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    // 为label添加Attributed
    
    self.presentlabel.attributedText = noteStr;
    
}


- (void)setPresent:(CGFloat)present{
    _present = present;
    //启动定时器
      [self createTimer];
     //修改波浪的幅度
    if (present <= 0.5) {
        _bigNumber = _MYframe.size.height * 0.1 * present * 2;
    }else{
        _bigNumber = _MYframe.size.height * 0.1 * (1 - present) * 2;
    }
}
@end
