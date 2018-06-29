//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"

@interface VWWWaterView ()
{
    float _currentLinePointY;
    
    float a;
    float b;
    
    BOOL jia;
    
    UILabel *_lab;
}

@property (nonatomic, strong) UILabel *awardLable;

@end


@implementation VWWWaterView

-(UILabel *)awardLable{
    if (!_awardLable) {
        _awardLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - 50 , 20)];
        _awardLable.text = @"(平台奖励)";
        _awardLable.centerY = self.centerY + 20;
        _awardLable.centerX = self.centerX;
        _awardLable.textAlignment = NSTextAlignmentRight;
        _awardLable.textColor = MainColor;
        _awardLable.font = [UIFont systemFontOfSize:8];
        [self addSubview:_awardLable];
    }
    return _awardLable;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        a = 1.5;
        b = 0;
        jia = NO;
        
        //年化
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _lab.centerY = self.centerY - 7;
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.textColor = MainColor;
        _lab.font = [UIFont systemFontOfSize:28];
        [self addSubview:_lab];
        _currentWaterColor = MainColor;
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)setPercentum:(float)percentum
{
    _percentum = percentum;
    _currentLinePointY = self.frame.size.height * (1.0f - _percentum);
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=1.5) {
        jia = NO;
    }
    
    
    b+=0.1;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=self.frame.size.width;x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);

}

-(void)setValue:(NSString *)value{
    _value = value;

    if ([value containsString:@"+"]) {
        //添加平台奖励
        [self addSubview:self.awardLable];
        
        NSMutableAttributedString *addStr = [[NSMutableAttributedString alloc] initWithString:@"%"];
        [addStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, addStr.length)];
        NSMutableAttributedString *valueStr = [[NSMutableAttributedString alloc] initWithString:value];
        [valueStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(0, valueStr.length)];
        [valueStr appendAttributedString:addStr];
        _lab.attributedText = valueStr;
        
    }else{
        if (self.awardLable) {
            [self.awardLable removeFromSuperview];
        }
        NSMutableAttributedString *addStr = [[NSMutableAttributedString alloc] initWithString:@"%"];
        [addStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, addStr.length)];
        NSMutableAttributedString *valueStr = [[NSMutableAttributedString alloc] initWithString:value];
        [valueStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(0, valueStr.length)];
        [valueStr appendAttributedString:addStr];
        _lab.attributedText = valueStr;
    }
}



@end
