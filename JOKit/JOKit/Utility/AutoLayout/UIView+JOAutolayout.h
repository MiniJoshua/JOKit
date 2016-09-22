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

#pragma mark - 左边的约束相关
#pragma mark -

- (void)layoutLeft:(CGFloat)distance;
- (void)layoutLeftView:(UIView *)leftView distance:(CGFloat)distance;
- (void)layoutLeftXView:(UIView *)leftView distance:(CGFloat)distance;
- (void)layoutLeft:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutLeftView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;    //与给定视图的左边的间距大小的约束
- (void)layoutLeftXView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;   //与给定视图左对齐的约束

#pragma mark - 右边的约束相关
#pragma mark -

- (void)layoutRight:(CGFloat)distance;
- (void)layoutRightView:(UIView *)rightView distance:(CGFloat)distance;
- (void)layoutRightXView:(UIView *)rightView distance:(CGFloat)distance;
- (void)layoutRight:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutRightView:(UIView *)rightView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图的右边的间距大小的约束
- (void)layoutRightXView:(UIView *)rightView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block; //与给定视图右对齐的约束

#pragma mark - 头部的约束相关
#pragma mark -

- (void)layoutTop:(CGFloat)distance;
- (void)layoutTopView:(UIView *)topView distance:(CGFloat)distance;
- (void)layoutTopYView:(UIView *)topView distance:(CGFloat)distance;
- (void)layoutTop:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutTopView:(UIView *)topView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图的上边的间距大小的约束
- (void)layoutTopYView:(UIView *)topView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block; //与给定视图上对齐的约束

#pragma mark - 底部的约束相关
#pragma mark -

- (void)layoutBottom:(CGFloat)distance;
- (void)layoutBottomView:(UIView *)bottomView distance:(CGFloat)distance;
- (void)layoutBottomYView:(UIView *)bottomView distance:(CGFloat)distance;
- (void)layoutBottom:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutBottomView:(UIView *)bottomView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;    //与给定视图的下边的间距大小的约束
- (void)layoutBottomYView:(UIView *)bottomView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block;   //与给定视图下对齐的约束

#pragma mark - 宽度的约束相关
#pragma mark -

- (void)layoutWidth:(CGFloat)width;
- (void)layoutWidthView:(UIView *)widthView ratio:(CGFloat)ratio;
- (void)layoutWidth:(CGFloat)width layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;    //与给定视图宽度比例大小的约束

#pragma mark - 高度的约束相关
#pragma mark -

- (void)layoutHeight:(CGFloat)height;
- (void)layoutHeightView:(UIView *)heightView ratio:(CGFloat)ratio;
- (void)layoutHeight:(CGFloat)height layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图高度比例大小的约束

#pragma mark - 中心的约束相关
#pragma mark -

- (void)layoutCenterXView:(UIView *)centerView;
- (void)layoutCenterYView:(UIView *)centerView;
- (void)layoutCenterView:(UIView *)centerView;
- (void)layoutCenterXView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图中心点x的相同的约束
- (void)layoutCenterYView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图中心点y的相同的约束
- (void)layoutCenterView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block;   //与给定视图中心点的相同的约束

#pragma mark - 宽高的约束相关.
#pragma mark -

- (void)layoutWidthHeightRatio:(CGFloat)ratio;
- (void)layoutHeightWidthRatio:(CGFloat)ratio;
- (void)layoutWidthHeightView:(UIView *)heightView ratio:(CGFloat)ratio;
- (void)layoutHeightWidthView:(UIView *)widthView ratio:(CGFloat)ratio;
- (void)layoutWidthHeightRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;   //宽高比的约束
- (void)layoutHeightWidthRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;   //高宽币的约束
- (void)layoutWidthHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block; //与给定视图的宽高比的约束
- (void)layoutHeightWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图的高宽比的约束

#pragma mark - 四周的约束相关.
#pragma mark -

- (void)layoutEdge:(UIEdgeInsets)edge;
- (void)layoutEdge:(UIEdgeInsets)edge layoutItemHandler:(JOViewLayoutBlock)block;

#pragma mark - size的约束相关.
#pragma mark -

- (void)layoutSize:(CGSize)size;
- (void)layoutSizeView:(UIView *)sizeView;
- (void)layoutSize:(CGSize)size layoutItemHandler:(JOViewLayoutBlock)block;
- (void)layoutSizeView:(UIView *)sizeView layoutItemHandler:(JOViewLayoutBlock)block;  //与给定视图的Size的约束

#pragma mark - same的约束相关.
#pragma mark -

- (void)layoutSameView:(UIView *)sameView;
- (void)layoutSameView:(UIView *)sameView layoutItemHandler:(JOViewLayoutBlock)block;   //与给定视图相同的约束

@end
