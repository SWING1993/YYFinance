//
//  GJCommonButton.h
//  CPH
//
//  Created by gaojun on 16/6/24.
//  Copyright © 2016年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJCommonButton : UIButton
/**
 *  调整button上图片和文字的显示比例,scale = 1.0表示只有图片， scale = 0.0表示只有文字
 */
@property (nonatomic,assign) CGFloat scale;

/**
 *  button图片"上边缘"距button"上边缘"的高度
 */
@property (nonatomic,assign) CGFloat imageEdageHeight;
/**
 *  button图片"左右边缘"距button"左右边缘"的长度
 */
@property (nonatomic,assign) CGFloat imageLeftRightEdageHeight;

/**    调整图片的scale     */
@property (nonatomic,assign) CGFloat imageScale;
@end
