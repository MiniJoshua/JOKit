//
//  JOCycleScrollView.h
//  JOKit
//
//  Created by 刘维 on 2017/6/8.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CycleScrollViewType) {
    
    CycleScrollViewTypeInfinite,  //无限循环的
    CycleScrollViewTypeLimited,  //有限循环的
};

typedef NS_ENUM(NSUInteger, CycleViewType) {
    
    CycleViewTypeLeft,
    CycleViewTypeMid,
    CycleViewTypeRight,
};

@interface JOCycleScrollView : UIScrollView

+ (JOCycleScrollView *)cycleScrollViewWithFrame:(CGRect)frame cycleType:(CycleScrollViewType)type;

/**
 设置左边视图,中视图,右边的视图
 
 @param leftView UIView
 @param midView UIView
 @param rightView UIView
 */
- (void)setViewWithLeft:(UIView *)leftView mid:(UIView *)midView right:(UIView *)rightView;

/**
 每次页面变化的时候的block回调.
 
 @param block void block
 */
- (void)pagesChanged:(void(^)(CycleViewType type, NSInteger index))block;

/**
 index变化的block回调.
 
 @param block void block.
 */
- (void)indexChanged:(void(^)(NSInteger index))block;

/**
 设置最大的页面数跟当前显示的页面数.
 PS:保证该方法在pagesChanged: 和 indexChanged:方法之后调用,
 这样才能保证初始化第一次能得到上面两个block的回调.
 
 @param pages 最大的页面数.
 @param index 当前显示的页面数.
 */
- (void)setMaxPages:(NSInteger)pages showIndex:(NSInteger)index;

@end
