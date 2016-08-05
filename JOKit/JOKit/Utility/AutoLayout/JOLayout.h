//
//  JOLayout.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/21.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "JOLayoutItem.h"

@interface JOLayout : NSObject

/**
 *  移除所有的约束
 *
 *  @param view       需要移除的约束的视图.
 *  @param relateView 相关联的视图.
 */
+ (void)removeAllLayoutWithView:(UIView *)view;
//移除与宽度关联的约束
+ (void)removeWidthLayoutWithView:(UIView *)view;
//移除与高度关联的约束
+ (void)removeHeightLayoutWithView:(UIView *)view;
//移除与左部关联的约束
+ (void)removeLeftLayoutWithView:(UIView *)view;
//移除与右部关联的约束
+ (void)removeRightLayoutWithView:(UIView *)view;
//移除与头部关联的约束
+ (void)removeTopLayoutWithWithView:(UIView *)view;
//移除与底部关联的约束
+ (void)removeBottomLayoutWithView:(UIView *)view;
//移除上下左右关联的约束
+ (void)removeEdgeLayoutWithView:(UIView *)view;
//移除与大小关联的约束
+ (void)removeSizeLayoutWithView:(UIView *)view;
//移除中心x关联的约束
+ (void)removeCenterXLayoutWithView:(UIView *)view;
//移除中心y关联的约束
+ (void)removeCenterYLayoutWithView:(UIView *)view;
//移除中心关联的约束
+ (void)removeCenterLayoutWithView:(UIView *)view;

/**
 *  根据LayoutItem去添加响应的约束.
 *
 *  @param item JOLayoutItem.
 */
+ (void)layoutWithItem:(JOLayoutItem *)item;

@end
