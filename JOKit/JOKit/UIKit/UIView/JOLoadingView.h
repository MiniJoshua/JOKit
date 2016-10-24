//
//  JOLodingView.h
//  JOKit
//
//  Created by 刘维 on 16/10/12.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOLoadingItem.h"

typedef NS_ENUM(NSUInteger, JOLoadingModel) {
    
    JOLoadingModelTraceCircleBall, //多个小球沿圆的路径运动的动画
    JOLoadingModelCircleDrawLine, //划线的动画(纯属无聊写的,一般你都不会用这个做loading动画的)
    JOLoadingModelSixPolygonals, //类似于守望先锋加载的那种动画
    JOLoadingModelCircleLine,    //一条线的按圆的路径的运动
};

/**
 Loading的相关属性设置的block.

 @param item JOLoadingItem.
 */
typedef void(^JOLoadingBlock) (JOLoadingItem *item);

@interface JOLoadingView : UIView

@property (nonatomic, copy) JOLoadingBlock lodingItemBlock;

/**
 根据给定的Model生成对应的Loading动画

 @param model        JOLoadingModel.
 @param loadingBlock JOLoadingBlock.

 @return JOLoadingView.
 */
+ (instancetype)loadingViewWithModel:(JOLoadingModel)model loadingItemBlock:(JOLoadingBlock)loadingBlock;

@end

