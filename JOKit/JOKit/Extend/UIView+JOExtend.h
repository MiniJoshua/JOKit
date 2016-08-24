//
//  UIView+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extend)

/**
 创建一个自动使用autolayout功能的对象.
 
 @return - 带有autolayout的对象.
 */
+ (instancetype)newAutoLayoutView;

/**
 @see 跟+ (instancetype)newAutoLayoutView功能一样.
 */
- (instancetype)initForAutoLayout;

/**
 *  获取View的截图
 *
 *  @return Image
 */
- (UIImage *)joViewImage;

/**
 *  移除视图上面所有的子视图
 */
- (void)removeAllSubviews;

@end
