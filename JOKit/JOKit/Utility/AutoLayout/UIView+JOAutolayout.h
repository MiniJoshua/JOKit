//
//  UIView+JOAutolayout.h
//  JOKit
//
//  Created by 刘维 on 16/8/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOLayoutItem.h"
#import "JOLayout.h"

typedef void(^JOViewLayoutBlock) (JOLayoutItem *layoutItem);

@interface UIView(JOAutolayout)

//左边的约束相关.
- (void)layoutLeft:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutLeftView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutLeftXView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;

//右边的约束相关.
- (void)layoutRight:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutRightView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutRightXView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;

//头部的约束相关.
- (void)layoutTop:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutTopView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutTopYView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;

//底部的约束相关
- (void)layoutBottom:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutBottomView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutBottomYView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;

//宽度的约束相关.
- (void)layoutWidth:(CGFloat)width layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;

//高度的约束相关.
- (void)layoutHeight:(CGFloat)height layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;

//中心的约束相关.
- (void)layoutCenterXView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutCenterYView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutCenterView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;

//宽高的约束相关.
- (void)layoutWidthHeightRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutHeightWidthRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutWidthHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutHeightWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;

//四周的约束相关.
- (void)layoutEdge:(UIEdgeInsets)edge layoutItemHandler:(JOViewLayoutBlock)block;

//size的约束相关.
- (void)layoutSize:(CGSize)size layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutSizeView:(UIView *)sizeView layoutItemHandler:(JOViewLayoutBlock)block;

//same的约束相关.
- (void)layoutSameView:(UIView *)sameView layoutItemHandler:(JOViewLayoutBlock)block;

@end
