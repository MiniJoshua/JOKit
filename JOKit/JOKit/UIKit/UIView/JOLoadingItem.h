//
//  JOLoadingItem.h
//  JOKit
//
//  Created by 刘维 on 16/10/12.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JOLoadingItem : NSObject

@end

@interface JOCircleBallLoadingItem : JOLoadingItem

//球的数量.
@property (nonatomic, assign) NSInteger         ballCount;
//每个球之间的间隔发车时间
@property (nonatomic, assign) NSTimeInterval    intervalTime;
//开始球的颜色
@property (nonatomic, strong) UIColor           *startColor;
//结束球的颜色 渐变过去的
@property (nonatomic, strong) UIColor           *endColor;
//球大小的半径.
@property (nonatomic, assign) CGFloat           ballRadius;
//第一个动画开始与第二个动画开始的间隔时间
@property (nonatomic, assign)  NSTimeInterval   animationIntervalTime;
//动画持续的时间
@property (nonatomic, assign) NSTimeInterval    animationDuration;

@end

@interface JOCircleLineDrawLoadingItem : JOLoadingItem

//最大划线的数量,建议不要超过300,不然可能出现掉帧的情况.
@property (nonatomic, assign) NSInteger         maxLineCount;
//线的宽度
@property (nonatomic, assign) CGFloat           lineWidth;
//线的颜色
@property (nonatomic, strong) UIColor           *lineColor;
//第一个球的半径大小 默认为3
@property (nonatomic, assign) CGFloat           ballOneRadius;
//第二个球的半径大小 默认为3
@property (nonatomic, assign) CGFloat           ballTwoRadius;
//第一个球的颜色.默认为白色.
@property (nonatomic, strong) UIColor           *ballOneColor;
//第二球个的颜色.默认为白色.
@property (nonatomic, strong) UIColor           *ballTwoColor;
//第一个球转动一圈需要的时间.
@property (nonatomic, assign) NSTimeInterval    ballOneDuration;
//第二个球转动一圈需要的时间.
@property (nonatomic, assign) NSTimeInterval    ballTwoDuration;
//两根画线之间的时间间隔.
@property (nonatomic, assign) NSTimeInterval    drawLineIntervalTime;

@end

@interface JOSixPolygonalsLoadingItem : JOLoadingItem

//多边形的颜色. 默认为 RGB为 150的灰色.
@property (nonatomic, strong) UIColor *polygonalColor;
//多边形的边框颜色. 默认为空白色
@property (nonatomic, strong) UIColor *polygonalBorderColor;
//多边形的边框大小. 默认为1
@property (nonatomic, assign) CGFloat polygonalBorderWidth;
//完整动画持续时间. 默认为4s
@property (nonatomic, assign) NSTimeInterval duration;
//若为负值只能对:左上左下与右上右下的六边形与中间六边形的间距大小  任何两个六边形上下的间距不能调整大小
//若为正值 则就能对所有的六边形的间距进行增加
@property (nonatomic, assign) CGFloat offset;
//两种动画的效果状态, YES:为更柔和的消失动画, NO:为更严格个动画消逝效果. 默认为YES
@property (nonatomic, assign) BOOL softState;
@end

@interface JOCircleLineLoadingItem : JOLoadingItem

//线的宽度.
@property (nonatomic, assign) CGFloat lineWidth;
//颜色的数组 详情见CAGradientLayer的该属性
@property (nonatomic, copy) NSArray *colors;
//与数组的大小保持一致,标示需要分隔颜色的位置. 0-1之间的值  详情见CAGradientLayer的该属性
@property (nonatomic, copy) NSArray *locations;
//开始的位置  详情见CAGradientLayer的该属性
@property (nonatomic, assign) CGPoint startPoint;
//结束的位置 详情见CAGradientLayer的该属性
@property (nonatomic, assign) CGPoint endPoint;
//完整的一次动画需要的时间
@property (nonatomic, assign) NSTimeInterval duration;

@end

